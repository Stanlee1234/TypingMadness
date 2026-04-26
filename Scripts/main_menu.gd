extends Control

func _on_start_pressed() -> void:
	SceneManager.change_scene("res://Scenes/main_game.tscn", { "pattern": "squares" })



func _on_start_mouse_entered() -> void:
	Blip.play()
