class_name Boss
extends CharacterBody2D

@export var energy_orb_scene: PackedScene
@export var switch_time: float = 5.0
@export var up_pos: Marker2D
@export var left_pos: Marker2D
@export var down_pos: Marker2D
@export var right_pos: Marker2D
@export var hp : int = 30

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_timer: Timer = $ShootTimer
@onready var hit_box: HitBox = $HitBox
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer

var player: CharacterBody2D
var positions: Array[Marker2D] = []
var current_index: int = 0

signal enemy_damaged(hurt_box : HurtBox)

func _ready() -> void:
	player = PlayerManager.player
	positions = [up_pos, left_pos, down_pos, right_pos]

	shoot_timer.wait_time = switch_time
	if not shoot_timer.timeout.is_connected(_on_shoot_timer_timeout):
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	current_index = 0
	global_position = positions[current_index].global_position
	_play_location_animation(current_index)

	_shoot_orb.call_deferred()

	shoot_timer.start()
	hit_box.Damaged.connect( _take_damage )

func _on_shoot_timer_timeout() -> void:
	visible = false
	await get_tree().create_timer(0.15).timeout

	current_index += 1
	if current_index >= positions.size():
		current_index = 0

	global_position = positions[current_index].global_position
	_play_location_animation(current_index)

	visible = true
	_shoot_orb()

func _play_location_animation(index: int) -> void:
	match index:
		0:
			animation_player.play("idle_down")
			sprite_2d.flip_h = false
		1:
			animation_player.play("idle_side")
			sprite_2d.flip_h = false
		2:
			animation_player.play("idle_up")
			sprite_2d.flip_h = true
		3:
			animation_player.play("idle_side")
			sprite_2d.flip_h = false

func _shoot_orb() -> void:
	if energy_orb_scene == null:
		print("Boss: energy_orb_scene is not assigned")
		return

	if not is_instance_valid(player):
		print("Boss: player is not valid")
		return

	var orb: EnergyOrb = energy_orb_scene.instantiate() as EnergyOrb
	if orb == null:
		print("Boss: orb could not be instantiated as EnergyOrb")
		return

	var dir: Vector2 = global_position.direction_to(player.global_position)

	orb.global_position = global_position + dir * 16.0
	orb.set_direction(dir)

	get_parent().add_child(orb)

	print("Boss global: ", global_position)
	print("Marker global: ", positions[current_index].global_position)
	print("Boss shot orb toward ", dir)

func _take_damage(hurt_box : HurtBox) -> void:
	hp -= hurt_box.damage
	if effect_animation_player:
		effect_animation_player.play("damaged_down")
	enemy_damaged.emit(hurt_box)
	if hp <= 0:
		await effect_animation_player.animation_finished
		queue_free()
