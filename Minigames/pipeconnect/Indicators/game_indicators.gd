extends Control

@export var indicator_sprites: Array[Texture] = []

func _ready() -> void:
	pass

func set_sprite(type: String):
	match type:
		"green_start":
			$Sprite2D.texture = indicator_sprites[0]
		"fossil_start":
			$Sprite2D.texture = indicator_sprites[1]
		"finish":
			$Sprite2D.texture = indicator_sprites[2]
