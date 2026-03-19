class_name HurtBox extends Area2D
@onready var attack_sound: AudioStreamPlayer2D = $"../../AttackSound"

@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect( AreaEntered )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func AreaEntered( a : Area2D ) -> void:
	if a is HitBox:
		a.TakeDamage( self )
		attack_sound.pitch_scale = randf_range(0.9, 1.1)
		attack_sound.play()
