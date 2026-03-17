extends Node

signal health_changed(current_health)

var max_health: int = 5
var current_health: int = 5

func set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	health_changed.emit(current_health)

func damage(amount: int) -> void:
	set_health(current_health - amount)

func heal(amount: int) -> void:
	set_health(current_health + amount)
