extends Control

@export var full_heart: Texture2D
@export var empty_heart: Texture2D

func _ready() -> void:
	var player = get_tree().current_scene.get_node_or_null("Player")
	if player == null:
		print("Player not found")
		return

	player.health_changed.connect(update_hearts)
	update_hearts(player.health, player.max_health)

func update_hearts(current_health: int, max_health: int) -> void:
	var hearts = $Hearts.get_children()

	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].texture = full_heart
		else:
			hearts[i].texture = empty_heart
