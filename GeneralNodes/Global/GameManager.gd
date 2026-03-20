extends Node

const START_SCENE := "res://Levels/Start Area/Scenes/Start_area.tscn"
var player_scene := preload("res://Player/Player.tscn")

var is_respawning := false
var elapsed_time: float = 0.0
var timer_running := true
var enemiesKilled : int = 0

func reset_timer_and_kills() -> void:
	elapsed_time = 0.0
	enemiesKilled = 0

func _process(delta: float) -> void:
	if timer_running:
		elapsed_time += delta

func get_time_string() -> String:
	var total_seconds := int(elapsed_time)
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	return "Elapsed Time: %02d:%02d" % [minutes, seconds]

func get_enemies_killed() -> String:
	var amount = "Enemies Killed: " + str(enemiesKilled)
	return amount

func set_enemies_killed() -> void:
	enemiesKilled += 1

func reset_timer() -> void:
	elapsed_time = 0.0

func player_died() -> void:
	if is_respawning:
		return
	is_respawning = true
	
	call_deferred("_death_sequence")

func _death_sequence() -> void:
	var scene = get_tree().current_scene
	if scene == null:
		is_respawning = false
		return

	# Show UI
	var player = scene.get_node_or_null("Player")
	if player:
		var death_ui = player.get_node_or_null("DeathUI")
		if death_ui:
			death_ui.visible = true

	# Wait 2 seconds
	await get_tree().create_timer(5.0).timeout
	reset_timer() 
	timer_running = true
	get_tree().change_scene_to_file(START_SCENE)
	is_respawning = false

func get_final_score() -> Dictionary:
	var max_time_score := 10000
	var time_penalty_per_second := 50
	var kill_value := 100

	var time_score = max(0, max_time_score - int(elapsed_time * time_penalty_per_second))
	var kill_score = enemiesKilled * kill_value
	var total_score = time_score + kill_score

	return {
		"time_score": time_score,
		"kill_score": kill_score,
		"total_score": total_score
	}


func spawn_player() -> void:
	var scene = get_tree().current_scene
	if scene == null:
		return

	var spawn_point = scene.get_node_or_null("SpawnPoint")
	if spawn_point == null:
		push_error("SpawnPoint not found in start scene")
		return

	var player = player_scene.instantiate()
	player.global_position = spawn_point.global_position
	scene.add_child(player)
