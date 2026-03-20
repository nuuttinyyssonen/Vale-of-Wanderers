class_name HurtBox extends Area2D
@export var attack_sound: AudioStream
@onready var player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(player)
	player.stream = attack_sound
	player.bus = "SFX"
	area_entered.connect(AreaEntered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func AreaEntered( a : Area2D ) -> void:
	if a is HitBox:
		a.TakeDamage( self )
		player.pitch_scale = randf_range(0.9, 1.1)
		player.play()
