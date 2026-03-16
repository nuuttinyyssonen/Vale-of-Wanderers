class_name EnemyState_Walk
extends State

@export var move_speed: float = 40.0
@onready var idle: EnemyState_Idle = $"../idle"

func Enter() -> void:
	actor.UpdateAnimation("walk")

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if actor.direction == Vector2.ZERO:
		return idle

	actor.velocity = actor.direction * move_speed

	if actor.SetDirection():
		actor.UpdateAnimation("walk")

	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
