extends CanvasLayer
@onready var main_menu: Button = $VBoxContainer/MainMenu

func _ready() -> void:
	main_menu.pressed.connect(_on_main_menu_pressed)

func _on_main_menu_pressed():
	print("pressed")
	get_tree().change_scene_to_file("res://GeneralNodes/UI/Scenes/main_menu.tscn")
