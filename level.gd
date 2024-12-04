extends Node2D

@export var level_num: int = 0
# Pauses user input for movement if true, set by signal to access panel
var minigame_active = false

func _ready():
	$HUD.level(level_num)
	parse_energyCells_connect()
	
func _process(_delta: float) -> void:
	if !minigame_active:
		pass
		# I need to allow user input here 

func parse_energyCells_connect():
	print("Parsing energy cells")
	for energyCell in $energyCells.get_children():
		energyCell.energyCells_collected.connect(_on_energyCells_collected)

func _on_energyCells_collected():	
	EnergyManager.add_energy(1)

func _on_door_player_entered(level):
	print_debug("reached level script")
	get_tree().change_scene_to_file(level)

func _on_terminal_interacted() -> void:
	minigame_active = true
	$CanvasLayer/pipeconnect_panel.visible = true
	print("Terminal interacted by player")

func _on_note_load_note_panel(_note_id: Variant) -> void:
	minigame_active = true
	$CanvasLayer/Journal.visible = true
	print("Note interacted by player")

func _on_journal_close_note_panel() -> void:
	minigame_active = false
	$CanvasLayer/Journal.visible = false
	print("Exit note panel pressed")

func _on_lightning_trap_die() -> void:
	# TODO: ADD APPROPRIATE DYING FUNCTIONALITY LATER
	get_tree().reload_current_scene.call_deferred()
