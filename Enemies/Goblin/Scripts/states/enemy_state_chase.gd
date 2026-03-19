class_name EnemyStateChase extends EnemyState

@export var anim_name : String = "attack"
@export var chase_speed : float = 60.0
@export var turn_rate : float = 0.25

@export_category("AI")
@export var state_aggro_duration : float = 0.4
@export var vision_area : VisionArea
@export var attack_area : HurtBox
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false

func init() -> void:
	if vision_area:
		vision_area.player_entered.connect( _on_player_enter_ )
		vision_area.player_exited.connect( _on_player_exit_ )
	pass

func enter() -> void:
	_timer = state_aggro_duration
	enemy.UpdateAnimation(anim_name)
	if attack_area:
		attack_area.monitoring = true
		
	pass
	
func exit() -> void:
	if attack_area:
		attack_area.monitoring = false
	_can_see_player = false
	pass

func Process(_delta: float) -> EnemyState:
	var player : Player = PlayerManager.player
	
	if player == null or not is_instance_valid(player):
		enemy.velocity = Vector2.ZERO
		return next_state
	var new_dir : Vector2 = enemy.global_position.direction_to(PlayerManager.player.global_position)
	_direction = lerp( _direction, new_dir, turn_rate )
	enemy.velocity = _direction * chase_speed
	if enemy.SetDirection(_direction):  
		enemy.UpdateAnimation(anim_name)
		
	if _can_see_player == false:
		_timer -= _delta
		if _timer <= 0:
			return next_state
	else:
		_timer = state_aggro_duration
	return null

func Physics(_delta: float) -> EnemyState:
	return null
	
func _on_player_enter_() -> void:
	_can_see_player = true
	goblin_state_machine.ChangeState(self)
	pass
	
func _on_player_exit_() -> void:
	_can_see_player = false
	pass
