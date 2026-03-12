extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer

var speed = 40
var direction = Vector2.ZERO
var last_direction = Vector2.DOWN
var damage := 1
var can_damage := true
var health = 1

func _ready():
	randomize()
	timer.timeout.connect(_on_timer_timeout)
	_on_timer_timeout()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body is Player:
			deal_damage(body)

	if direction == Vector2.ZERO:
		if last_direction == Vector2.RIGHT:
			anim.flip_h = false
			anim.play("idle")
		elif last_direction == Vector2.LEFT:
			anim.flip_h = true
			anim.play("idle")
		elif last_direction == Vector2.DOWN:
			anim.play("idle")
		elif last_direction == Vector2.UP:
			anim.play("idle")
		return

	if abs(direction.x) > abs(direction.y):
		anim.play("move")
		if direction.x > 0:
			anim.flip_h = true
			last_direction = Vector2.RIGHT
		else:
			anim.flip_h = false
			last_direction = Vector2.LEFT
	else:
		anim.flip_h = false
		if direction.y > 0:
			anim.play("move")
			last_direction = Vector2.DOWN
		else:
			anim.play("move")
			last_direction = Vector2.UP

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
	if randf() < 0.35:
		direction = Vector2.ZERO
	else:
		direction = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized()
