extends Node2D

@onready var player = $Player

func _ready() -> void:
	GameManager.spawn_player()
	PlayerState.respawn()
	if NavigationManager.spawn_door_tag == "":
		return

	for door in get_tree().get_nodes_in_group("doors"):
		if door.door_tag == NavigationManager.spawn_door_tag:
			player.global_position = door.spawn.global_position
			NavigationManager.spawn_door_tag = ""
			break
