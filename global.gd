extends Node

# For settings later, to disable audio
var audio :bool = true

var gems_collected : int = 0
var coins_collected : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("global ready")

func _input(event):
	if event.is_action_pressed("return_to_main_menu"): 
		get_tree().change_scene_to_file("res://main_menu.tscn")
	
	if event.is_action_pressed("reset_level"):
		get_tree().reload_current_scene.call_deferred()
