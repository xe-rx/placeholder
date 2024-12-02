extends TextureRect

@export var player: CharacterBody2D
@export var energy_bar_sprites: Array[Texture] = []  # Sprites assigned in the Inspector
var value: int = 0
var maxEnergy: int = 7

func _ready():
	update_energy_sprite()

# Updates the energy bar
func update_energyBar():
	value += 1  # Increment energy
	value = clamp(value, 0, maxEnergy)  # Ensure it stays within range
	print("Current energy value: ", value)  # Debugging output to track value
	
	update_energy_sprite()  # Update sprite based on value

# Update the energy bar sprite based on the current value
func update_energy_sprite():
	var num_stages = energy_bar_sprites.size()
	var stage = value
	stage = clamp(stage, 0, num_stages - 1)
	self.texture = energy_bar_sprites[stage]
