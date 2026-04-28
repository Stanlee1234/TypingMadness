extends Control

func _on_back_button_pressed() -> void:
	SceneManager.change_scene("res://Scenes/main_menu.tscn", {
	"pattern": "squares",
	"color": Color(0.268, 0.268, 0.268, 1.0),
	"invert_on_enter": true,
	"invert_on_leave": false,
})
