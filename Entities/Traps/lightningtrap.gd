extends Node2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer

var is_active = false

func _ready():
	timer.start()
	switch_to_safe()

func _on_Timer_timeout():
	print("Timer triggered")
	if is_active:
		switch_to_safe()
	else:
		switch_to_active()

func switch_to_safe():
	is_active = false
	print("Switching to safe state")
	sprite.animation = "Safe"  
	sprite.play()
	collision_shape.disabled = true

func switch_to_active():
	is_active = true
	print("Switching to active state")
	sprite.animation = "Active"
	sprite.play()
	collision_shape.disabled = false
