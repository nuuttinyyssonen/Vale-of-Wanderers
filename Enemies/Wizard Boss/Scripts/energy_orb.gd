class_name EnergyOrb
extends Node2D

@export var speed: float = 220.0
@export var life_time: float = 5.0

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	print("Orb spawned at: ", global_position)

	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = life_time
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
	rotation = direction.angle()
	print("Orb direction set: ", direction)
