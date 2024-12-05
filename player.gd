extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME = 0.2  # Time allowed after leaving the ground to still jump
const JUMP_BUFFER_TIME = 0.2  # Time allowed for buffering a jump before landing

# Gravity value
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Coyote time and jump buffer timers
var coyote_time_remaining = 0.0
var jump_buffer_remaining = 0.0

# Used to pause user input in level script
var level_script

func _ready():
	level_script = get_parent()

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Update timers for coyote time and jump buffer
	if is_on_floor():
		coyote_time_remaining = COYOTE_TIME  # Reset coyote time if on the ground
	else:
		coyote_time_remaining -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_remaining = JUMP_BUFFER_TIME  # Set jump buffer timer

	jump_buffer_remaining -= delta

	# Handle jump
	if (coyote_time_remaining > 0 or is_on_floor()) and jump_buffer_remaining > 0:
		velocity.y = JUMP_VELOCITY
		# Jump sfx
		$JumpSfx.play()
		jump_buffer_remaining = 0  # Reset jump buffer after jumping

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$PlayerSprite.play("run")
		$PlayerSprite.flip_h = direction == -1
	else:
		$PlayerSprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED / 1.5)

	if not is_on_floor():
		$PlayerSprite.play("jump")
	
	move_and_slide()
