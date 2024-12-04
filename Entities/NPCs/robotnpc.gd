extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var area2d = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D

@export var energy_cell_cost: int = 1

var player = null  # Stores the player node when it enters the Area2D
var is_awake = false  # Tracks whether the NPC has been woken up

func _ready():
	sprite.animation = "off"
	sprite.play()

func _on_body_entered(body):
	if body.name == "Player":
		player = body
		if is_awake:
			display_dialogue(player, "Press E to Interact")
		else:
			display_dialogue(player, "Press E to wake up (Costs 1 Energy Cell)")

func _on_body_exited(body):
	if body.name == "Player":
		clear_dialogue(body)
		player = null

func _process(delta: float) -> void:
	if player and Input.is_action_just_pressed("interact"):
		if is_awake:
			interact_with_awake_robot(player)
		else:
			interact_with_robot(player)

func interact_with_robot(player):
	var dialogue_label = player.get_node("Dialogue")
	if EnergyManager.value >= energy_cell_cost:
		EnergyManager.value -= energy_cell_cost
		EnergyManager.add_energy(-1)
		sprite.animation = "off_to_idle"
		sprite.play()
		display_dialogue(player, "Waking up...")
	else:
		display_dialogue(player, "Not sufficient energy cells")

func interact_with_awake_robot(player):
	TextManager.queue_text("Wheh, how long have i been asleep for?...")
	TextManager.queue_text("Anyways, that is for later. This is an old factory used by researchers do develop green alternatives for fossil fuel")
	TextManager.queue_text("My terminal tells me that the machines are still running on fossil fuel though. Something must've happened, its so quiet here")
	TextManager.queue_text("We developed energy cells that are completely green, can you help me get the factory running on clean energy? There must be plenty energy cells scattered around!")
	TextManager.queue_text("The researchers all had their own reasons to work on this project, if you are set on helping me you should find your own aswell!")
	TextManager.queue_text("There's a lot of documentation from philosophers scattered around, read them and try to make up your mind on why this is important! I know you can do it.")




func _on_off_to_idle_finished():
	# Handle transition to "idle" animation
	if sprite.animation == "off_to_idle":
		sprite.animation = "idle"
		sprite.play()
		clear_dialogue(player)
		is_awake = true  # Mark the NPC as awake

func display_dialogue(body, txt):
	var dialogue_label = body.get_node("Dialogue")
	if dialogue_label:
		dialogue_label.text = txt
		dialogue_label.visible = true
	else:
		print("Warning: Dialogue node not found on body:", body.name)

func clear_dialogue(body):
	# Note every time node is reloaded it gives a new character body ID, so after reloading this function might bug
	var dialogue_label = body.get_node("Dialogue")
	if dialogue_label:
		dialogue_label.text = ""
		dialogue_label.visible = false
	else:
		print("Warning: Dialogue node not found on body:", body.name)
