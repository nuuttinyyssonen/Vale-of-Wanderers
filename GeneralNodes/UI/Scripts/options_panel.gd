extends Control

@onready var music_slider: HSlider = $MusicSlider
@onready var sfx_slider: HSlider = $SfxSlider

func _ready() -> void:
	music_slider.min_value = 0
	music_slider.max_value = 100
	music_slider.step = 1

	sfx_slider.min_value = 0
	sfx_slider.max_value = 100
	sfx_slider.step = 1

	music_slider.value = db_to_percent(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = db_to_percent(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)

func _on_music_slider_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, percent_to_db(value))

func _on_sfx_slider_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, percent_to_db(value))

func percent_to_db(value: float) -> float:
	if value <= 0:
		return -80.0
	return linear_to_db(value / 100.0)

func db_to_percent(db: float) -> float:
	if db <= -80.0:
		return 0.0
	return db_to_linear(db) * 100.0

func _on_back_button_pressed() -> void:
	visible = false
