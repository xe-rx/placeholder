extends Area2D
var note_entered: bool = false
var note_id = 0

signal load_note_panel(note_id)

@export var first_note: String = "Press E to read"

func _process(delta):
	if Input.is_action_just_pressed("interact") and note_entered:
		emit_signal("load_note_panel", note_id)

func _on_body_entered(body):
	if body.name == "Player":
		display_dialogue(body, first_note)
		note_entered = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		clear_dialogue(body);
		note_entered = false

func clear_dialogue(body):
	var dialogue_label = body.get_node("Dialogue")

	dialogue_label.visible = false
	dialogue_label.text = " "

func display_dialogue(body, txt):
	var dialogue_label = body.get_node("Dialogue")
	
	dialogue_label.text = txt
	dialogue_label.visible = true
	
