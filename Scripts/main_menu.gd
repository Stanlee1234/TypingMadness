extends Control

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(Bgm, "volume_db", -20.0, 1.0)

func _on_start_pressed() -> void:
	SceneManager.change_scene("res://Scenes/main_game.tscn", {
	"pattern": "squares",
	"color": Color(0.268, 0.268, 0.268, 1.0)
})



func _on_start_mouse_entered() -> void:
	Blip.play()


func _on_settings_pressed() -> void:
	SceneManager.change_scene("res://Scenes/settings.tscn", {
	"pattern": "squares",
	"color": Color(0.268, 0.268, 0.268, 1.0)
})
