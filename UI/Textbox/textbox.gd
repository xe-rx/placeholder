extends CanvasLayer

# Constants
const CHAR_READ_RATE = 0.042

# Onready Variables
@onready var textbox_container = $TextBoxContainer
@onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/End
@onready var content = $TextBoxContainer/MarginContainer/HBoxContainer/Content

var tween: Tween = null

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _process(float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				content.visible_ratio = 1.0
				tween.kill()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				textbox_container.hide()

func queue_text(next_text):
	text_queue.push_back(next_text)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Starting in state:", current_state)
	hide_textbox()
	queue_text("In a small village nestled between rolling hills and the shimmering sea, there was a grove of ancient oaks known as the Grove of Silent Oaks.")
	queue_text("For centuries, the villagers believed the grove to be sacred. It was said that if you sat beneath the canopy and asked a question, the rustling leaves would whisper answers from the deep wisdom of the earth.")
	queue_text("One day, a young philosopher named Lila came to the grove. She was troubled, for the world seemed out of balance.")

# Add text to the textbox and animate it
func display_text():
	var text = text_queue.pop_front()
	change_state(State.READING)
	content.text = text
	show_textbox()
	if tween:
		tween.kill()
	content.visible_ratio = 0.0
	tween = get_tree().create_tween()
	tween.tween_property(content, "visible_ratio", 1.0, len(text) * CHAR_READ_RATE)
	tween.connect("finished", Callable(self, "_on_tween_finished"))
	tween.finished.connect(self._on_tween_finished)

func _on_tween_finished():
	change_state(State.FINISHED)
	end_symbol.text = "v"

# Hide the textbox
func hide_textbox() -> void:
	start_symbol.text = ""
	end_symbol.text = ""
	content.text = ""
	textbox_container.hide()

# Show the textbox
func show_textbox() -> void:
	start_symbol.text = "*"
	textbox_container.show()

func change_state(next_state):
	match next_state:
		State.READY:
			print("Changing from state: ", current_state,"to: ", next_state)
		State.READING:
			print("Changing from state: ", current_state,"to: ", next_state)
		State.FINISHED:
			print("Changing from state: ", current_state,"to: ", next_state)
	current_state = next_state
