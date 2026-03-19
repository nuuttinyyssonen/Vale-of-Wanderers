class_name State_Stun extends State

@export var knoback_speed : float = 200.0
@export var decelrate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

@onready var idle: State_Idle = $"../idle"

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null

func Enter() -> void:
	actor.UpdateAnimation("stun")
	actor.animation_player.animation_finished.connect(_animation_finished)
	
	direction = actor.global_position.direction_to(hurt_box.global_position)
	actor.velocity = direction * -knoback_speed
	actor.SetDirection()
	
	actor.make_invulnerable( invulnerable_duration )
	pass


func Exit() -> void:
	next_state = null
	actor.animation_player.animation_finished.disconnect(_animation_finished)
	pass

func init() -> void:
	actor.player_damaged.connect(_player_damaged_)


func Process(_delta: float) -> State:
	return next_state


func Physics(_delta: float) -> State:
	return null


func HandleInput(_event: InputEvent) -> State:
	return null

func _player_damaged_(_hurt_box: HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState(self)
	pass

func _animation_finished(_a: String) -> void:
	next_state = idle
