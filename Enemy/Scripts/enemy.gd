class_name Enemy
extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var velocity_speed: float = 40.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_timer: Timer = $Timer
@onready var enemy_state_machine: PlayerStateMachine = $StateMachine

signal DirectionChanged(new_direction: Vector2)

func _ready() -> void:
	enemy_state_machine.Initialize(self)
	randomize()
	move_timer.timeout.connect(_on_move_timer_timeout)
	_on_move_timer_timeout()
	$HitBox.Damaged.connect( TakeDamge )

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_move_timer_timeout() -> void:
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

func TakeDamge( _damage: int ) -> void:
	queue_free()
	pass
	
	
