extends Area2D

@export var level : String = "1"
var door_entered = false
signal player_entered(level)

# Animation states
enum DoorState { CLOSED, OPENING, OPEN }
var door_state = DoorState.CLOSED

# Reference to AnimatedSprite2D node
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body):
	door_entered = true
	print("Door entered ", door_entered)

func _on_body_exited(body: Node2D) -> void:
	door_entered = false
	print("Door entered ", door_entered)

func _process(delta: float) -> void:
	if door_entered and Input.is_action_just_pressed("interact"):
		if door_state == DoorState.CLOSED:
			play_opening_animation()
		elif door_state == DoorState.OPEN:
			print("if statement entered")
			player_entered.emit(level)

func play_opening_animation() -> void:
	if door_state == DoorState.CLOSED:
		door_state = DoorState.OPENING
		animated_sprite.play("opening")
		animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_animation_finished() -> void:
	if door_state == DoorState.OPENING:
		door_state = DoorState.OPEN
		animated_sprite.play("open")  # Play the open animation permanently
		animated_sprite.disconnect("animation_finished", Callable(self, "_on_animation_finished"))
