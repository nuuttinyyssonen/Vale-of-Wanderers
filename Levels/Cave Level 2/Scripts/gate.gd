extends StaticBody2D

var opened := false

func open_gate() -> void:
	if opened:
		return
	opened = true

	for child in get_children():
		if child is AnimatedSprite2D:
			child.play("Open")

	$CollisionShape2D.set_deferred("disabled", true)
