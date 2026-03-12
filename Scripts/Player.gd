extends CharacterBody2D

class_name Player

@onready var anim = $AnimatedSprite2D
@onready var attack_area = $AttackArea

var speed = 400
var last_direction = Vector2.DOWN
var is_attacking = false
var max_health := 5
var health := 5

func _ready():
	anim.animation_finished.connect(_on_animation_finished)
	if anim.sprite_frames:
		anim.sprite_frames.set_animation_loop("attack_side", false)
		anim.sprite_frames.set_animation_loop("attack_down", false)
		anim.sprite_frames.set_animation_loop("attack_up", false)

func _physics_process(delta):
	if is_attacking:
		velocity = Vector2.ZERO
		return

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

	if Input.is_action_just_pressed("attack"):
		start_attack()
		return

	velocity = input_vector * speed
	move_and_slide()

	if input_vector == Vector2.ZERO:
		if last_direction == Vector2.RIGHT:
			anim.flip_h = false
			anim.play("idle_side")
		elif last_direction == Vector2.LEFT:
			anim.flip_h = true
			anim.play("idle_side")
		elif last_direction == Vector2.DOWN:
			anim.play("idle_down")
		elif last_direction == Vector2.UP:
			anim.play("idle_up")
		return

	if abs(input_vector.x) > abs(input_vector.y):
		anim.play("walk_side")
		if input_vector.x > 0:
			anim.flip_h = false
			last_direction = Vector2.RIGHT
		else:
			anim.flip_h = true
			last_direction = Vector2.LEFT
	else:
		anim.flip_h = false
		if input_vector.y > 0:
			anim.play("walk_down")
			last_direction = Vector2.DOWN
		else:
			anim.play("walk_up")
			last_direction = Vector2.UP

func start_attack():
	if is_attacking:
		return

	is_attacking = true
	attack_area.monitoring = true
	velocity = Vector2.ZERO

	if last_direction == Vector2.RIGHT:
		anim.flip_h = false
		anim.play("attack_side")
	elif last_direction == Vector2.LEFT:
		anim.flip_h = true
		anim.play("attack_side")
	elif last_direction == Vector2.DOWN:
		anim.play("attack_down")
	elif last_direction == Vector2.UP:
		anim.play("attack_up")

func _on_animation_finished():
	if anim.animation == "attack_side" or anim.animation == "attack_down" or anim.animation == "attack_up":
		is_attacking = false
		attack_area.monitoring = false

func take_damage(amount: int) -> void:
	health -= amount
	print("Player health: ", health)

	if health <= 0:
		die()

func die() -> void:
	print("Player died")
	queue_free()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
