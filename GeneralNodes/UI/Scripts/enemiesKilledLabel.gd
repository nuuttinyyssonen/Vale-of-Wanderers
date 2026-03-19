extends Label

func _process(delta):
	text = GameManager.get_enemies_killed()
