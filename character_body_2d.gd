extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var speed = 400
var last_direction = Vector2.DOWN

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

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
