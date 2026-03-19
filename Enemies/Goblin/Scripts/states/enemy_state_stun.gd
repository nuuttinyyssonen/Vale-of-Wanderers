class_name EnemyStateStun extends EnemyState

@export var knoback_speed : float = 200.0
@export var decelrate_speed : float = 10.0
@export var anim_name : String = "damaged"

@export_category("AI")
@export var next_state : EnemyState

var hurt_box : HurtBox
var _direction : Vector2
var _animation_finished : bool = false

func enter() -> void:
	_animation_finished = false
	_direction = enemy.global_position.direction_to(enemy.player.global_position)
	
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -knoback_speed
	
	enemy.UpdateStunAnimation(anim_name)
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass

func Process(_delta: float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelrate_speed * _delta
	return null

func exit() -> void:
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	
func init() -> void:
	enemy.enemy_damaged.connect(_enemy_damaged_)
	
func _enemy_damaged_(_hurt_box: HurtBox) -> void:
	hurt_box = _hurt_box
	goblin_state_machine.ChangeState(self)
	pass

func Physics(_delta: float) -> EnemyState:
	return null

func _on_animation_finished(_a: String) -> void:
	_animation_finished = true
