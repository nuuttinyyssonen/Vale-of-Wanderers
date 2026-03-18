class_name GoblinEnemy
extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var velocity_speed: float = 80.0
var is_dead: bool = false

@export var chase_range: float = 300.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_timer: Timer = $Timer
@onready var enemy_state_machine: PlayerStateMachine = $StateMachine
@onready var damage_area = $DamageArea
@onready var attack_sound: AudioStreamPlayer2D = $AttackSound
@onready var player: Player = get_tree().get_first_node_in_group("player") as Player

signal DirectionChanged(new_direction: Vector2)

func _ready() -> void:
	enemy_state_machine.Initialize(self)
	randomize()
	move_timer.timeout.connect(_on_move_timer_timeout)
	_on_move_timer_timeout()
	$HitBox.Damaged.connect(TakeDamage)

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	_update_chase()
	SetDirection()
	velocity = direction * velocity_speed
	move_and_slide()

func _update_chase() -> void:
	if player == null:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	if distance > chase_range:
		return

	if move_timer.is_stopped():
		_on_move_timer_timeout()
		return

	direction = _get_cardinal_direction(to_player)
	SetDirection()

func _on_move_timer_timeout() -> void:
	if player != null and global_position.distance_to(player.global_position) <= chase_range:
		move_timer.wait_time = 0.5
		move_timer.start()
		return
	
	var dirs = [
		Vector2.ZERO,
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,
		Vector2.DOWN
	]

	direction = dirs[randi() % dirs.size()]
	move_timer.wait_time = randf_range(1.0, 3.0)
	move_timer.start()

func _get_cardinal_direction(input_direction: Vector2) -> Vector2:
	if input_direction == Vector2.ZERO:
		return Vector2.ZERO

	if abs(input_direction.x) > abs(input_direction.y):
		return Vector2.LEFT if input_direction.x < 0 else Vector2.RIGHT

	return Vector2.UP if input_direction.y < 0 else Vector2.DOWN

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false

	var new_dir = _get_cardinal_direction(direction)

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir
	DirectionChanged.emit(cardinal_direction)

	if sprite != null:
		if cardinal_direction == Vector2.LEFT:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

	UpdateAnimation("walk")
	return true

func FacePlayer() -> void:
	if player == null:
		return

	var to_player = player.global_position - global_position
	if to_player == Vector2.ZERO:
		return

	direction = _get_cardinal_direction(to_player)
	SetDirection()

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func TakeDamage(_damage: int) -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	move_timer.stop()

	_disable_damage()
	queue_free()

func _disable_damage() -> void:
	$Interactions/HurtBox.set_deferred("monitoring", false)
	$Interactions/HurtBox.set_deferred("monitorable", false)
	$HitBox.set_deferred("monitoring", false)
	$HitBox.set_deferred("monitorable", false)

	if $Interactions/HurtBox.has_node("CollisionShape2D"):
		$Interactions/HurtBox/CollisionShape2D.set_deferred("disabled", true)

	if $HitBox.has_node("CollisionShape2D"):
		$HitBox/CollisionShape2D.set_deferred("disabled", true)

func _on_damage_area_body_entered(body: Node2D) -> void:
	if is_dead:
		return

	if body is Player:
		FacePlayer()
		UpdateAnimation("attack")
		attack_sound.pitch_scale = randf_range(0.9, 1.1)
		attack_sound.play()
		body.TakeDamage(1)
