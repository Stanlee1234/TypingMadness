extends Control

@onready var pause_menu = $PauseMenu

var current_fruit = null
var fruit_scene = preload("res://Scenes/fruit.tscn")
var master_bus_idx = AudioServer.get_bus_index("Master")
var low_pass_effect = AudioServer.get_bus_effect(master_bus_idx, 0)

func _ready() -> void:
	if WordManager.is_ready:
		_on_dictionary_loaded()
	else:
		WordManager.dictionary_loaded.connect(_on_dictionary_loaded)
	var tween = create_tween()
	tween.tween_property(Bgm, "volume_db", -23.0, 1.0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func _on_dictionary_loaded() -> void:
	print("Game Ready! Start mashing keys!")
	spawn_fruit()

func spawn_fruit() -> void:
	var new_fruit = fruit_scene.instantiate()
	new_fruit.position = Vector2(randf_range(100, 1000), -50) 
	add_child.call_deferred(new_fruit)
	current_fruit = new_fruit
	new_fruit.tree_exited.connect(spawn_fruit)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.unicode == 0:
			return
			
		var typed_char: String = String.chr(event.unicode).to_lower()
		if typed_char != "":
			if is_instance_valid(current_fruit):
				var correct_key = current_fruit.type_letter(typed_char)

				if not correct_key:
					shake_screen(3.0)

func shake_screen(strength:float) -> void:
	var tween = create_tween()
	for i in range(5):
		var random_movement = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * strength
		tween.tween_property(self, "position", random_movement, 0.02)
		tween.tween_property(self, "position", Vector2.ZERO, 0.02)

func toggle_pause() -> void:
	var is_currently_paused = get_tree().paused
	
	if is_currently_paused:
		get_tree().paused = false
		pause_menu.hide()
		var tween = create_tween()
		tween.tween_property(low_pass_effect, "cutoff_hz", 20500.0, 0.5)
	else:
		get_tree().paused = true
		pause_menu.show()
		var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(low_pass_effect, "cutoff_hz", 700.0, 0.5)

func _on_resume_button_pressed() -> void:
	toggle_pause()
