extends Area2D

@export var level :String = ""
signal player_entered(level)

# Added a signal to pass data to door script in level scene for level value
func _on_body_entered(body):
	print_debug("entered door script")
	if body.name == "Player":
		print("went into if-statement")
		player_entered.emit(level)
