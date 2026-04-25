extends Control

@onready var label = $Label

func _ready():
	label.text = FactManager.current_fact
	FactManager.fetch_new_fact()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
