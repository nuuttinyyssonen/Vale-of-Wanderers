extends Node

const scene_start = preload("res://Scenes/Start_area.tscn")
const scene_cave = preload("res://Scenes/Cave.tscn")

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"Start_area":
			scene_to_load = scene_start
		"cave":
			scene_to_load = scene_cave
	
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
