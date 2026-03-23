class_name State_Attack extends State
@onready var walk: State_Walk = $"../walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State_Idle = $"../idle"
@onready var attack_animation: AnimationPlayer = $"../../Sprite2D/AttackSprite/AnimationPlayer"
@onready var attack_sound: AudioStreamPlayer2D = $"../../AttackSound"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"
@onready var interactions: Node2D = $"../../Interactions"
@onready var hurt_shape : CollisionShape2D = $"../../Interactions/HurtBox/CollisionShape2D"
var attacking : bool = false

func Enter() -> void:
	actor.UpdateAnimation("attack")
	var dir = actor.AnimDirection()
	attack_animation.play("attack_" + dir)
	
	attack_sound.pitch_scale = randf_range(0.9, 1.1)
	attack_sound.play()
	
	if dir == "up":
		hurt_shape.position = Vector2(0, 20)
	else:
		hurt_shape.position = Vector2.ZERO
	
	hurt_box.monitoring = true
	
	animation_player.animation_finished.connect(EndAttack)
	attacking = true
	pass


func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.monitoring = false
	pass


func Process(_delta: float) -> State:
	actor.velocity = Vector2.ZERO
	if attacking == false:
		if actor.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


func Physics(_delta: float) -> State:
	return null


func HandleInput(_event: InputEvent) -> State:
	return null


func EndAttack(_newAnimName : String) -> void:
	attacking = false
