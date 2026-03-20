class_name Boss
extends CharacterBody2D

@export var energy_orb_scene: PackedScene
@export var switch_time: float = 5.0
@export var up_pos: Marker2D
@export var left_pos: Marker2D
@export var down_pos: Marker2D
@export var right_pos: Marker2D
@export var hp : int = 3

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_timer: Timer = $ShootTimer
@onready var hit_box: HitBox = $HitBox
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var score_label: Label = $"../EndingUI/VBoxContainer/ScoreLabel"
@onready var kill_label: Label = $"../EndingUI/VBoxContainer/KillLabel"
@onready var time_label: Label = $"../EndingUI/VBoxContainer/TimeLabel"
@onready var ending_ui: CanvasLayer = $"../EndingUI"

var player: CharacterBody2D
var positions: Array[Marker2D] = []
var current_index: int = 0

signal enemy_damaged(hurt_box : HurtBox)

func _ready() -> void:
	randomize()
	player = PlayerManager.player
	positions = [up_pos, left_pos, down_pos, right_pos]

	shoot_timer.wait_time = switch_time
	if not shoot_timer.timeout.is_connected(_on_shoot_timer_timeout):
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	current_index = 0
	global_position = positions[current_index].global_position
	_play_location_animation(current_index)
	await get_tree().create_timer(2.0).timeout
	
	_shoot_orb.call_deferred()
	shoot_timer.start()
	hit_box.Damaged.connect( _take_damage )

func _on_shoot_timer_timeout() -> void:
	visible = false
	await get_tree().create_timer(0.15).timeout

	current_index = randi() % positions.size()

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
			sprite_2d.flip_h = false
		3:
			animation_player.play("idle_side")
			sprite_2d.flip_h = true

func _shoot_orb() -> void:
	var base_dir: Vector2 = global_position.direction_to(player.global_position)
	var angles := [-15.0, -5.0, 5.0, 15.0]

	for angle_deg in angles:
		var dir := base_dir.rotated(deg_to_rad(angle_deg))
		var orb: EnergyOrb = energy_orb_scene.instantiate() as EnergyOrb
		orb.global_position = global_position + dir * 16.0
		orb.set_direction(dir)
		get_parent().add_child(orb)

func _take_damage(hurt_box : HurtBox) -> void:
	hp -= hurt_box.damage
	if effect_animation_player:
		effect_animation_player.play("damaged_down")
	enemy_damaged.emit(hurt_box)
	if hp <= 0:
		await effect_animation_player.animation_finished
		queue_free()
		var score_data = GameManager.get_final_score()
		show_score(score_data)

func show_score(data: Dictionary):
	ending_ui.visible = true
	time_label.text = "⏱ Time: %d" % data["time_score"]
	kill_label.text = "💀 Kills: %d" % data["kill_score"]
	score_label.text = "⭐ Total: %d" % data["total_score"]
