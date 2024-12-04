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

func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if TextManager.has_text():
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

func _ready() -> void:
	print("Starting in state:", current_state)
	hide_textbox()
	TextManager.connect("queue_text_signal", Callable(self, "_on_text_queued"))

# Handle text queued signal
func _on_text_queued(next_text: String) -> void:
	if current_state == State.READY:
		display_text()

# Add text to the textbox and animate it
func display_text():
	var text = TextManager.get_next_text()
	if text == "":
		return
	change_state(State.READING)
	content.text = text
	show_textbox()
	if tween:
		tween.kill()
	content.visible_ratio = 0.0
	tween = get_tree().create_tween()
	tween.tween_property(content, "visible_ratio", 1.0, len(text) * CHAR_READ_RATE)
	tween.connect("finished", Callable(self, "_on_tween_finished"))

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
			print("Changing from state: ", current_state, "to: ", next_state)
		State.READING:
			print("Changing from state: ", current_state, "to: ", next_state)
		State.FINISHED:
			print("Changing from state: ", current_state, "to: ", next_state)
	current_state = next_state
