extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		$CoinSfx.play()
		Global.coins_collected += 1
		# calling hide so that the sprite disappearing does not wait for the sfx
		hide()

# to not interrupt soundfx
func _on_coin_sfx_finished():
		queue_free()
