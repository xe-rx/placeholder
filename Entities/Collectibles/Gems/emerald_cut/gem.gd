extends Area2D

signal gem_collected

func _on_body_entered(body):
	if body.name == "Player":
		$GemSfx.play()
		Global.gems_collected += 1
		gem_collected.emit()
		# calling hide so that the sprite disappearing does not wait for the sfx
		hide()
# to not interrupt sfx
func _on_gem_sfx_finished():
		queue_free()
