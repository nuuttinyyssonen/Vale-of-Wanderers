extends Node

const scene_start = preload("res://Levels/Start Area/Scenes/Start_area.tscn")
const scene_cave = preload("res://Levels/Cave Level 1/Scenes/Cave.tscn")
const scene_cave_level_2 = preload("res://Levels/Cave Level 2/Scenes/Cave Level 2.tscn")

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"Start_area":
			scene_to_load = scene_start
		"cave":
			scene_to_load = scene_cave
		"Cave Level 2":
			scene_to_load = scene_cave_level_2
	
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		call_deferred("_deferred_go_to_level", scene_to_load)

func _deferred_go_to_level(scene_to_load: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene_to_load)
