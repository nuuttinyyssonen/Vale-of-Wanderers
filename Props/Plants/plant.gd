class_name Plant extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.Damaged.connect( TakeDamge )
	pass # Replace with function body.

func TakeDamge( _damage: int ) -> void:
	queue_free()
	pass
