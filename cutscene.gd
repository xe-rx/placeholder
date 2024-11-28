extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://lvl_1.tscn")
