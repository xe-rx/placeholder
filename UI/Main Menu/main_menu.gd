extends Node2D

func _ready():
	print("MainMenu Ready")
	$VFlow/StartButton.grab_focus()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://cutscene.tscn")


func _on_toggle_fullscreen_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
