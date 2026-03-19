class_name Enemy
extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var velocity_speed: float = 80.0
var is_dead: bool = false

@export var chase_range: float = 300.0

@onready var hit_box: HitBox = $HitBox
@onready var hurt_box: HurtBox = $Interactions/HurtBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_timer: Timer = $Timer
@onready var enemy_state_machine: PlayerStateMachine = $StateMachine
@onready var damage_area = $DamageArea
@onready var attack_sound: AudioStreamPlayer2D = $AttackSound
@onready var player: Player = get_tree().get_first_node_in_group("player") as Player

signal DirectionChanged(new_direction: Vector2)
signal enemy_damaged(hurt_box: HurtBox)

func _ready() -> void:
	enemy_state_machine.Initialize(self)
	randomize()
	move_timer.timeout.connect(_on_move_timer_timeout)
	_on_move_timer_timeout()
	hit_box.Damaged.connect( TakeDamage )

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	_update_chase()
	move_and_slide()

func _update_chase() -> void:
	if player == null:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	if distance <= chase_range:
		direction = to_player.normalized()

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

func SetDirection() -> bool:
	var new_direction: Vector2 = cardinal_direction

	if direction == Vector2.ZERO:
		return false

	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN

	if new_direction == cardinal_direction:
		return false

	cardinal_direction = new_direction
	DirectionChanged.emit(new_direction)
	return true

func UpdateAnimation(state: String) -> void:
	animation_player.play(state)
	
func TakeDamage(hurt_box: HurtBox) -> void:
	if is_dead:
		return
	enemy_damaged.emit(hit_box)
	is_dead = true
	velocity = Vector2.ZERO
	move_timer.stop()

	_disable_damage()

	UpdateAnimation("death")

	await animation_player.animation_finished
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
		attack_sound.pitch_scale = randf_range(0.9, 1.1)
		attack_sound.play()
		body._take_damage(hurt_box)
