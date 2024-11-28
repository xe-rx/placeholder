extends Node2D

@export var level_num :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.level(level_num)
	parse_gems_connect()

# Parsing all gems on the level and connecting to gem function 
# that handles updating the HUD
func parse_gems_connect():
	set_gems_label()
	for gem in $Gems.get_children():
		gem.gem_collected.connect(_on_gem_collected)

# Updates the gems_label in HUD
func _on_gem_collected():	
	set_gems_label()

func set_gems_label():
	$HUD.gems(Global.gems_collected)

# Receives signal data from door script and sends player to correct level
func _on_door_player_entered(level):
	print_debug("reached level script")
	get_tree().change_scene_to_file(level)
