class_name State_Attack extends State
@onready var walk: State_Walk = $"../walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State_Idle = $"../idle"
@onready var attack_animation: AnimationPlayer = $"../../Sprite2D/AttackSprite/AnimationPlayer"
@onready var attack_sound: AudioStreamPlayer2D = $"../../AttackSound"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"
@onready var interactions: Node2D = $"../../Interactions"

var attacking : bool = false

func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_animation.play("attack_" + player.AnimDirection())
	
	attack_sound.pitch_scale = randf_range(0.9, 1.1)
	attack_sound.play()
	
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
	player.velocity = Vector2.ZERO
	if attacking == false:
		if player.direction == Vector2.ZERO:
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
