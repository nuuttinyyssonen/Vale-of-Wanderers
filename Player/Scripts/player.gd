class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hit_box: HitBox = $HitBox

var current_health: int = 8
var max_health: int = 8
var is_dead : bool = false

signal DirectionChanged(new_direction : Vector2)
signal player_damaged(hurt_box : HurtBox)

var invulnerable : bool = false

func _ready() -> void:
	PlayerManager.player = self
	current_health = PlayerState.current_health
	PlayerState.health_changed.emit(PlayerState.current_health)
	state_machine.Initialize(self)
	hit_box.Damaged.connect(_take_damage)
	update_hp(5)
	pass


func _process(_delta: float) -> void:
	if is_dead:
		return
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	pass
	

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	PlayerState.set_health(current_health)
	if current_health > 0:
		player_damaged.emit(hurt_box)
	else:
		var tween = create_tween()
		tween.tween_property(sprite, "rotation", deg_to_rad(90), 0.3)
		tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.5)
		tween.parallel().tween_property(sprite, "position:y", sprite.position.y + 10, 0.3)
		is_dead = true
		set_physics_process(false)
		set_process(false)
		GameManager.player_died()
	pass

func update_hp( delta : int ) -> void:
	current_health = clampi(current_health + delta, 0, max_health)
	pass

func make_invulnerable(_duration : float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true

func SetDirection() -> bool:
	var new_direction : Vector2 = cardinal_direction
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
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true


func UpdateAnimation(state : String) -> void:
	animation_player.play(state + "_" + AnimDirection())
	pass

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
