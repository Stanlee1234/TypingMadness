extends Control

var current_virus = null
var virus_scene = preload("res://Scenes/fruit.tscn")

func _ready() -> void:
	if WordManager.is_ready:
		_on_dictionary_loaded()
	else:
		WordManager.dictionary_loaded.connect(_on_dictionary_loaded)
	var tween = create_tween()
	tween.tween_property(Bgm, "volume_db", -27.0, 1.0)

func _on_dictionary_loaded() -> void:
	print("Game Ready! Start mashing keys!")
	spawn_virus()

func spawn_virus() -> void:
	var new_virus = virus_scene.instantiate()
	new_virus.position = Vector2(randf_range(100, 1000), -50) 
	add_child.call_deferred(new_virus)
	current_virus = new_virus
	new_virus.tree_exited.connect(spawn_virus)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.unicode == 0:
			return
			
		var typed_char: String = String.chr(event.unicode).to_lower()
		if typed_char != "":
			if is_instance_valid(current_virus):
				var correct_key = current_virus.type_letter(typed_char)

				if not correct_key:
					shake_screen(3.0)

func shake_screen(strength:float) -> void:
	var tween = create_tween()
	for i in range(5):
		var random_movement = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * strength
		tween.tween_property(self, "position", random_movement, 0.02)
		tween.tween_property(self, "position", Vector2.ZERO, 0.02)
