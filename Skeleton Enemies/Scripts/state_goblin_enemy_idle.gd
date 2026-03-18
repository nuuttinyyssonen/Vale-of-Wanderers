class_name Goblin_EnemyState_Idle
extends State

@onready var walk: Goblin_EnemyState_Walk = $"../walk"

func Enter() -> void:
	actor.velocity = Vector2.ZERO
	if not actor.is_attacking:
		actor.UpdateAnimation("idle")

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if actor.is_attacking:
		actor.velocity = Vector2.ZERO
		return null

	if actor.direction != Vector2.ZERO:
		return walk
	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
