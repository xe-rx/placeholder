extends Node2D
@onready var collision_shape = $Area2D/FullCollision
@onready var half_collision_shape = $Area2D/HalfCollision
@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer

var is_active = false
signal die

func _ready():
	timer.start()
	switch_to_safe()

func _on_Timer_timeout():
	if is_active:
		switch_to_safe()
	else:
		switch_to_active()

func switch_to_safe():
	is_active = false
	sprite.animation = "safe"  
	sprite.play()
	half_collision_shape.disabled = true
	collision_shape.disabled = true

func switch_to_active():
	is_active = true
	sprite.animation = "active"
	sprite.play()
	half_collision_shape.disabled = false
	await get_tree().create_timer(0.3).timeout
	collision_shape.disabled = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("die")
		
