extends Control

@export var pipe_sprites: Array[Texture] = []
var current_pipe_index: int = 0
var current_rotation_index: int = 0
var current_connections: Dictionary = {}

# Signal used to run validation algorithm
signal pipe_rotated

var pipe_directions = {
	0: [ {"up": false, "down": false, "left": true, "right": true},
		 {"up": true, "down": true, "left": false, "right": false},
		 {"up": false, "down": false, "left": true, "right": true},
		 {"up": true, "down": true, "left": false, "right": false}
	],
	1: [ {"up": false, "down": true, "left": false, "right": true},
		 {"up": false, "down": true, "left": true, "right": false},
		 {"up": true, "down": false, "left": true, "right": false},
		 {"up": true, "down": false, "left": false, "right": true}
	]
}

func _ready() -> void:
	$Sprite2D.texture = pipe_sprites[current_pipe_index]
	update_sprite_rotation()
	update_connections()
	if $Area2D:
		$Area2D.connect("input_event", Callable(self, "_on_Area2D_input_event"))


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and MOUSE_BUTTON_LEFT:
		current_rotation_index = (current_rotation_index + 1) % 4
		update_sprite_rotation()
		update_connections()
		emit_signal("pipe_rotated")


func update_connections():
	if pipe_directions.has(current_pipe_index):
		current_connections = pipe_directions[current_pipe_index][current_rotation_index]

func update_sprite_rotation():
	$Sprite2D.rotation_degrees = current_rotation_index * 90
