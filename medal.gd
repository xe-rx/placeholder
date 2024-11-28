extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		Global.coins_collected += 10
		print(Global.coins_collected)
		queue_free()
