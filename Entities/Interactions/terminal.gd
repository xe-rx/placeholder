extends Area2D

# Confusing documentation, just means its inside the collision shape of terminal
var terminal_entered = false

@export var terminal: String = "Press E to enter"

func _process(delta):
	if Input.is_action_just_pressed("E") and terminal_entered:
		pass

func _on_body_entered(body):
	if body.name == "Player":
		display_dialogue(body, terminal)
		terminal_entered = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		clear_dialogue(body);
		terminal_entered = false

func clear_dialogue(body):
	var dialogue_label = body.get_node("Dialogue")

	dialogue_label.visible = false
	dialogue_label.text = " "


func display_dialogue(body, txt):
	var dialogue_label = body.get_node("Dialogue")
	
	dialogue_label.text = txt
	dialogue_label.visible = true
	