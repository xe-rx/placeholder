extends Node2D

@export var level_num :int = 0

# Pauses user input for movement if true, set by signal to access panel
var minigame_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.level(level_num)
	parse_energyCells_connect()
	
func _process(_delta: float) -> void:
	if !minigame_active:
		pass
		# I need to allow user input here 
	
# Parsing all energyCells on the level and connecting to energyCell function 
# that handles updating the HUD
func parse_energyCells_connect():
	print("Parsing energy cells")
	for energyCell in $energyCells.get_children():
		energyCell.energyCells_collected.connect(_on_energyCells_collected)

# Updates the energyCells_label in HUD
func _on_energyCells_collected():	
	$HUD/Control/barWrapper/energyWrapper/energyBar.update_energyBar()


# Receives signal data from door script and sends player to correct level
func _on_door_player_entered(level):
	print_debug("reached level script")
	get_tree().change_scene_to_file(level)

# Signal coming from terminal, creating panel
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
