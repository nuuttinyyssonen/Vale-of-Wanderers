class_name State_Idle extends State
@onready var walk: State_Walk = $"../walk"
@onready var attack: State_Attack = $"../attack"


func Enter() -> void:
	actor.UpdateAnimation("idle")
	pass


func Exit() -> void:
	pass


func Process(_delta: float) -> State:
	if actor.direction != Vector2.ZERO:
		return walk
	actor.velocity = Vector2.ZERO
	return null


func Physics(_delta: float) -> State:
	return null


func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
