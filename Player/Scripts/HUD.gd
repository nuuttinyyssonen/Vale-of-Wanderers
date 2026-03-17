extends HBoxContainer

@onready var hearts = get_children()

var player = null

var heart_texture = preload("res://Player/sprites/gui-health.png")
var full_region = Rect2(17.8, 0, 9, 8)
var empty_region = Rect2(0, 0, 9, 8)

func _ready():
	call_deferred("_connect_to_player")

func _connect_to_player():
	player = get_tree().get_first_node_in_group("player")

	if player == null:
		push_error("Player not found in group 'player'")
		return

	player.health_changed.connect(update_hearts)
	update_hearts(player.current_health)

func set_heart_region(heart: TextureRect, region: Rect2):
	var atlas = AtlasTexture.new()
	atlas.atlas = heart_texture
	atlas.region = region
	heart.texture = atlas

func update_hearts(current_health: int):
	for i in range(hearts.size()):
		if i < current_health:
			set_heart_region(hearts[i], full_region)
		else:
			set_heart_region(hearts[i], empty_region)
