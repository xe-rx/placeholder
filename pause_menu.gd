extends Control

# Listens for keypress 
func _process(delta):
	if Input.is_action_just_pressed("pause_esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause_esc") and get_tree().paused:
		resume()

func resume():
	get_tree().paused = false
	self.visible = false
	
func pause():
	get_tree().paused = true
	self.visible = true
		
# BUTTON FUNCTIONS:
func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	pass # Replace with function body.
