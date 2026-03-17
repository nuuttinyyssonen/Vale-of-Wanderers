extends HBoxContainer

@onready var hearts = get_children()

var heart_texture = preload("res://Player/sprites/gui-health.png")
var full_region = Rect2(17.8, 0, 9, 8)
var empty_region = Rect2(0, 0, 9, 8)

func _ready():
	if not PlayerState.health_changed.is_connected(update_hearts):
		PlayerState.health_changed.connect(update_hearts)

	update_hearts(PlayerState.current_health)

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
