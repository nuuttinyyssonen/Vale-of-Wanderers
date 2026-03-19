class_name EnemyState_Death extends State

func Enter() -> void:
	actor.velocity = Vector2.ZERO
	actor.UpdateAnimation("death")
	actor.get_node("HitBox").monitoring = false

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
