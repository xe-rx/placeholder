extends Node  # No need for TextureRect here

var value: int = 0
var maxEnergy: int = 7

signal energy_updated  # Signal to notify UI of changes

func has_energy(cost: int) -> bool:
	return value >= cost

func consume_energy(cost: int) -> bool:
	if has_energy(cost):
		value -= cost
		value = clamp(value, 0, maxEnergy)
		emit_signal("energy_updated", value)
		return true
	return false

func add_energy(amount: int):
	value += amount
	value = clamp(value, 0, maxEnergy)
	emit_signal("energy_updated", value)

func get_energy() -> int:
	return value
