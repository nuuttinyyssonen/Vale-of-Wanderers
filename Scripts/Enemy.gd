extends CharacterBody2D

enum State {
	IDLE,
	WANDER,
	CHASE
}

@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer

var state: State = State.IDLE

var speed := 40.0
var chase_speed := 60.0
var direction := Vector2.ZERO
var last_direction := Vector2.DOWN

var damage := 1
var can_damage := true
var health := 1

var player: Player = null
var aggro_range := 200.0
var lose_aggro_range := 540.0

func _ready():
	randomize()
	timer.timeout.connect(_on_timer_timeout)
	player = get_tree().get_first_node_in_group("player") as Player
	_on_timer_timeout()

func _physics_process(_delta):
	update_state()

	match state:
		State.IDLE:
			velocity = Vector2.ZERO

		State.WANDER:
			velocity = direction * speed

		State.CHASE:
			if player:
				var chase_dir = global_position.direction_to(player.global_position)
				velocity = chase_dir * chase_speed
				last_direction = chase_dir

	move_and_slide()
	check_player_collision()
	update_animation()

func update_state():
	if player == null:
		return

	var dist = global_position.distance_to(player.global_position)

	match state:
		State.IDLE, State.WANDER:
			if dist <= aggro_range:
				state = State.CHASE

		State.CHASE:
			if dist > lose_aggro_range:
				state = State.IDLE
				_on_timer_timeout()

func check_player_collision():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body is Player:
			deal_damage(body)

func deal_damage(player):
	if can_damage:
		player.take_damage(damage)
		can_damage = false
		await get_tree().create_timer(0.5).timeout
		can_damage = true

func take_damage(amount: int) -> void:
	health -= amount
	print("Slime health: ", health)

	if health <= 0:
		die()

func die() -> void:
	print("Slime died")
	queue_free()

func _on_timer_timeout():
	if state == State.CHASE:
		return

	if randf() < 0.35:
		state = State.IDLE
		direction = Vector2.ZERO
	else:
		state = State.WANDER
		direction = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized()

func update_animation():
	var anim_dir = velocity
	if anim_dir == Vector2.ZERO:
		anim_dir = last_direction
	else:
		last_direction = anim_dir.normalized()

	if abs(anim_dir.x) > abs(anim_dir.y):
		if velocity == Vector2.ZERO:
			anim.play("idle")
		else:
			anim.play("move")

		anim.flip_h = anim_dir.x < 0
	else:
		anim.flip_h = false
		if velocity == Vector2.ZERO:
			anim.play("idle")
		else:
			anim.play("move")
