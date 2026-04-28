extends Control

@onready var label = $Fact

func _ready():
	label.text = FactManager.current_fact
	FactManager.fetch_new_fact()
	var tween = create_tween()
	tween.tween_property(Bgm, "volume_db", -20.0, 1.0)

func _on_main_menu_mouse_entered() -> void:
	Blip.play()

func _on_try_again_mouse_entered() -> void:
	Blip.play()

func _on_main_menu_pressed() -> void:
	SceneManager.change_scene("res://Scenes/main_menu.tscn", {
	"pattern": "squares",
	"color": Color(0.268, 0.268, 0.268, 1.0)
})

func _on_try_again_pressed() -> void:
	SceneManager.change_scene("res://Scenes/main_game.tscn", {
	"pattern": "squares",
	"color": Color(0.268, 0.268, 0.268, 1.0)
})
