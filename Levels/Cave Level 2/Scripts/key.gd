extends Area2D

@export var gate_path: NodePath
@onready var gate: Node2D = $"../Gate"

var opened := false

func _on_body_entered(body: Node) -> void:
	if opened:
		return
	
	if not body.is_in_group("player"):
		return

	opened = true

	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("Open")

	#var gate = get_node_or_null(gate_path)
	if gate:
		gate.open_gate()

	$CollisionShape2D.set_deferred("disabled", true)
