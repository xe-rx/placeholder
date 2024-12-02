# This file contains all logic for the minigame, it pulls from both pipe.gd
# and game_indicators.gd for the instances of the parts of the minigame loaded
# into the script.

extends Control
var pipes_grid = []
var gridsize = 6

var green_start_pos = Vector2.ZERO  # Starting point for green energy
var harmful_start_pos = Vector2.ZERO  # Starting point for harmful energy
var finish_pos = Vector2.ZERO  # Shared endpoint

# passed with 0, fossil. passed with 1, green.
signal puzzle_finished(int)

#value dictionary:
# 0: straight pipe
# 1: curved pipe
# 2: end
# 3: green start
# 4: fossil start
var predefined_puzzle = [
	[3, 0, 0, 1, 4, 0],  # Row 0
	[1, 1, 1, 1, 0, 1],  # Row 1
	[1, 1, 0, 1, 0, 0],  # Row 2
	[1, 0, 0, 1, 0, 1],  # Row 3
	[0, 1, 0, 0, 2, 0],  # Row 4
	[1, 0, 0, 1, 1, 0]   # Row 5
]

var predefined_rotations = [
	[0, 0, 0, 2, 0, 0],  # Row 0
	[1, 1, 1, 0, 0, 1],  # Row 1
	[1, 0, 0, 1, 0, 0],  # Row 2
	[0, 0, 0, 1, 0, 1],  # Row 3
	[0, 1, 0, 0, 1, 0],  # Row 4
	[1, 0, 0, 1, 1, 0]   # Row 5
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	define_positions()
	load_pipes(gridsize)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func define_positions():
	for y in range(predefined_puzzle.size()):
		for x in range(predefined_puzzle[y].size()):
			var value = predefined_puzzle[y][x]
			match value:
				3:  # Green Start
					green_start_pos = Vector2(x, y)
				4:  # Harmful Start
					harmful_start_pos = Vector2(x, y)
				2:  # Finish
					finish_pos = Vector2(x, y)


func load_pipes(grid_size):
	var pipe_scene = preload("res://Minigames/pipeconnect/pipe.tscn")
	var indicators_scene = preload("res://Minigames/pipeconnect/Indicators/game_indicators.tscn")
	
	for y in range(grid_size):
		var row = []
		for x in range(grid_size):
			var pipe_instance = null
			var cell_value = predefined_puzzle[y][x]
			var rotation_index = predefined_rotations[y][x]

			if cell_value == 3:  # Green start
				pipe_instance = indicators_scene.instantiate()
				pipe_instance.set_sprite("green_start")
			elif cell_value == 4:  # Harmful start
				pipe_instance = indicators_scene.instantiate()
				pipe_instance.set_sprite("fossil_start")
			elif cell_value == 2:  # Finish
				pipe_instance = indicators_scene.instantiate()
				pipe_instance.set_sprite("finish")
			else:
				# Instantiate a regular pipe
				pipe_instance = pipe_scene.instantiate()
				pipe_instance.current_pipe_index = cell_value
				pipe_instance.current_rotation_index = rotation_index
				pipe_instance.update_sprite_rotation()
				pipe_instance.update_connections()

			$terminal_panel/Panel/Panel/GridContainer.add_child(pipe_instance)

			if cell_value not in [2, 3, 4]:  # Regular pipes only
				pipe_instance.connect("pipe_rotated", Callable(self, "_on_pipe_rotated"))

			row.append(pipe_instance)
		pipes_grid.append(row)


func _on_pipe_rotated():
	# Validate the puzzle whenever a pipe is rotated
	if validate_puzzle():
		print("Puzzle is solved!")
	else:
		print("Puzzle is incomplete or incorrect.")

func validate_puzzle() -> bool:
	var visited_green = []
	var green_valid = is_path_valid(green_start_pos, finish_pos, visited_green)

	var visited_harmful = []
	var harmful_valid = is_path_valid(harmful_start_pos, finish_pos, visited_harmful)

	if green_valid:
		finish_puzzle("green")
		return true
	if harmful_valid:
		finish_puzzle("fossil")
		return true

	return false



func finish_puzzle(type):
	if type == "green":
		print("Puzzle completed successfully the green way!")
	if type == "fossil":
		print("Puzzle completed successfully but you hurt the environemnt!")
	# Add any additional logic for when the puzzle is completed:
	# - Disable further input on pipes
	# - Play a success animation or sound
	# - Transition to another scene


func is_path_valid(current_pos: Vector2, finish_pos: Vector2, visited: Array) -> bool:

	if current_pos == finish_pos:
		return true

	if current_pos in visited:
		return false

	visited.append(current_pos)

	var x = int(current_pos.x)
	var y = int(current_pos.y)
	var tile = pipes_grid[y][x]

	var directions = {
		"up": {"neighbor_pos": Vector2(x, y - 1), "opposite_dir": "down"},
		"down": {"neighbor_pos": Vector2(x, y + 1), "opposite_dir": "up"},
		"left": {"neighbor_pos": Vector2(x - 1, y), "opposite_dir": "right"},
		"right": {"neighbor_pos": Vector2(x + 1, y), "opposite_dir": "left"}
	}

	if tile.has_method("update_connections"):
		# The tile is a pipe
		var connections = tile.current_connections

		for dir in ["up", "down", "left", "right"]:
			if connections.get(dir, false):
				var neighbor_data = directions[dir]
				var neighbor_pos = neighbor_data["neighbor_pos"]
				var opposite_dir = neighbor_data["opposite_dir"]

				if neighbor_pos.x >= 0 and neighbor_pos.y >= 0 and neighbor_pos.x < gridsize and neighbor_pos.y < gridsize:
					if neighbor_pos not in visited:
						var neighbor_tile = pipes_grid[int(neighbor_pos.y)][int(neighbor_pos.x)]
						if neighbor_tile:
							if neighbor_tile.has_method("update_connections"):
								# Neighbor is a pipe
								var neighbor_connections = neighbor_tile.current_connections
								if neighbor_connections.get(opposite_dir, false):
									if is_path_valid(neighbor_pos, finish_pos, visited):
										visited.pop_back()
										return true
							else:
								# Neighbor is an indicator
								if is_path_valid(neighbor_pos, finish_pos, visited):
									visited.pop_back()
									return true
	else:
		# The tile is an indicator
		# Consider all directions since indicators are connected on all sides
		for dir in ["up", "down", "left", "right"]:
			var neighbor_data = directions[dir]
			var neighbor_pos = neighbor_data["neighbor_pos"]
			var opposite_dir = neighbor_data["opposite_dir"]

			if neighbor_pos.x >= 0 and neighbor_pos.y >= 0 and neighbor_pos.x < gridsize and neighbor_pos.y < gridsize:
				if neighbor_pos not in visited:
					var neighbor_tile = pipes_grid[int(neighbor_pos.y)][int(neighbor_pos.x)]
					if neighbor_tile:
						if neighbor_tile.has_method("update_connections"):
							# Neighbor is a pipe
							var neighbor_connections = neighbor_tile.current_connections
							if neighbor_connections.get(opposite_dir, false):
								if is_path_valid(neighbor_pos, finish_pos, visited):
									visited.pop_back()
									return true
						else:
							# Neighbor is an indicator
							if is_path_valid(neighbor_pos, finish_pos, visited):
								visited.pop_back()
								return true

	visited.pop_back()
	return false

func handle_indicator(current_pos: Vector2, finish_pos: Vector2, visited: Array) -> bool:
	var x = int(current_pos.x)
	var y = int(current_pos.y)

	var directions = {
		"up": {"neighbor_pos": Vector2(x, y - 1), "opposite_dir": "down"},
		"down": {"neighbor_pos": Vector2(x, y + 1), "opposite_dir": "up"},
		"left": {"neighbor_pos": Vector2(x - 1, y), "opposite_dir": "right"},
		"right": {"neighbor_pos": Vector2(x + 1, y), "opposite_dir": "left"}
	}

	for dir in directions.keys():
		var neighbor_data = directions[dir]
		var neighbor_pos = neighbor_data["neighbor_pos"]
		var opposite_dir = neighbor_data["opposite_dir"]

		if neighbor_pos.x >= 0 and neighbor_pos.y >= 0 and neighbor_pos.x < gridsize and neighbor_pos.y < gridsize:
			if neighbor_pos not in visited:
				var neighbor = pipes_grid[int(neighbor_pos.y)][int(neighbor_pos.x)]
				if neighbor.has_method("update_connections"):
					if neighbor.current_connections[opposite_dir]:
						if is_path_valid(neighbor_pos, finish_pos, visited):
							return true
				else:
					# Neighbor is an indicator or finish
					if is_path_valid(neighbor_pos, finish_pos, visited):
						return true

	# Backtrack: Remove current position from visited
	visited.erase(current_pos)
	return false
