class_name State_Walk extends State

@export var move_speed : float = 200.0
@onready var idle: State_Idle = $"../idle"
@onready var attack: State_Attack = $"../attack"

func Enter() -> void:
	actor.UpdateAnimation("walk")
	pass


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
	if _event.is_action_pressed("attack"):
		return attack
	return null
