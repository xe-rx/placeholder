extends Area2D

@export var first_note: String = "This is a note, press E to inspect it!"

func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == "Player":
		display_dialogue(body, first_note)
		
func display_dialogue(body, txt):
	var dialogue_label = body.get_node("Dialogue")
	
	dialogue_label.text = txt
	dialogue_label.visible = true
	
