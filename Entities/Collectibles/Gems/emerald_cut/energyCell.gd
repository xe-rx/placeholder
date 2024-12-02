extends Area2D

signal energyCells_collected

func _on_body_entered(body):
	if body.name == "Player":
		$GemSfx.play()
		Global.energyCells_collected += 1
		energyCells_collected.emit()

		# Disable collision and hide the node
		$CollisionShape2D.disabled = true
		hide()

		# Queue the node for deletion
		queue_free()

func _on_energyCell_sfx_finished():
	print("Energy cell fully freed!")
	queue_free()
