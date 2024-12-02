extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# used to pause user input in level script
var level_script

func _ready():
	level_script = get_parent()

func _physics_process(delta):
	if level_script.minigame_active:
		return # Pass all movement physics when minigame is active
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		# Jump sfx
		#if Global.audio = true: !!! figure out why this Global reference does not work
		$JumpSfx.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$PlayerSprite.play("run")
		if direction == -1:
			$PlayerSprite.flip_h = true
		else:
			$PlayerSprite.flip_h = false
	else:
		$PlayerSprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED / 1.5)
	if not is_on_floor():
		$PlayerSprite.play("jump")
	move_and_slide()
