extends Control
@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
@onready var options_panel: VBoxContainer = $OptionsPanel
@onready var Main_Menu: VBoxContainer = $VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not music_player.playing:
		music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	music_player.stop()
	GameManager.reset_timer_and_kills()
	get_tree().change_scene_to_file("res://Levels/Start Area/Scenes/Start_area.tscn")


func _on_settings_pressed() -> void:
	Main_Menu.visible = false
	options_panel.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	Main_Menu.visible = true
	options_panel.visible = false
	
