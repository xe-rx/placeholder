extends Area2D

@export var first_note: String = "Press E to read"

func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == "Player":
		display_dialogue(body, first_note)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		clear_dialogue(body);

func clear_dialogue(body):
	var dialogue_label = body.get_node("Dialogue")

	dialogue_label.visible = false
	dialogue_label.text = " "

func display_dialogue(body, txt):
	var dialogue_label = body.get_node("Dialogue")
	
	dialogue_label.text = txt
	dialogue_label.visible = true
	
