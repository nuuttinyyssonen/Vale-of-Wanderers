extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer

var speed = 40
var direction = Vector2.ZERO
var last_direction = Vector2.DOWN

func _ready():
	randomize()
	timer.timeout.connect(_on_timer_timeout)
	_on_timer_timeout()

func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()

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

func _on_timer_timeout():
	if randf() < 0.35:
		direction = Vector2.ZERO
	else:
		direction = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized()
