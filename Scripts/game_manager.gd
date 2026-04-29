extends Node

var juice: int = 0

var juice_multiplier: int = 1
var auto_typer_level: int = 0
var slow_fall_level: int = 0

signal juice_updated(new_amount)

func add_juice(amount: int) -> void:
	juice += amount * juice_multiplier
	juice_updated.emit(juice)

func spend_juice(amount: int) -> bool:
	if juice >= amount:
		juice -= amount
		juice_updated.emit(juice)
		return true
	return false
