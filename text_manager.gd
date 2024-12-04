extends Node

# Signal to communicate with the Textbox
signal queue_text_signal

# Text queue
var text_queue: Array = []

# Add text to the queue
func queue_text(next_text: String) -> void:
	text_queue.append(next_text)
	emit_signal("queue_text_signal", next_text)

# Get the next text from the queue
func get_next_text() -> String:
	return text_queue.pop_front() if not text_queue.is_empty() else ""

# Check if the queue is empty
func has_text() -> bool:
	return not text_queue.is_empty()
