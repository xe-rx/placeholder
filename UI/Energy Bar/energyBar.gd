extends TextureRect

@export var energy_bar_sprites: Array[Texture] = []

func _ready():
	if energy_bar_sprites.size() == 0:
		print("Error: energy_bar_sprites not initialized!")
		return

	EnergyManager.connect("energy_updated", Callable(self, "_on_energy_updated"))

	_on_energy_updated(EnergyManager.get_energy())

func _on_energy_updated(current_value: int):
	print(current_value)
	var num_stages = energy_bar_sprites.size()
	var stage = clamp(current_value, 0, num_stages - 1)
	self.texture = energy_bar_sprites[stage]
