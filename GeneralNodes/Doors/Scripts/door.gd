extends Area2D

class_name Door

@export var door_tag: String
@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn

func _ready() -> void:
	add_to_group("doors")

func _on_body_entered(body: Node2D) -> void:
	print("Player entered door")
	print("Going to level: ", destination_level_tag)
	print("Going to door: ", destination_door_tag)
	if body is Player:
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
