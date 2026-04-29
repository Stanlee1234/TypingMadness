extends Area2D

var fall_speed: float = 100.0 
var rotation_speed: float = 0.0
var original_word: String = ""
var target_word: String = "" 

@onready var label = $RichTextLabel
@onready var explode = $Explode
@onready var click = $Click
var explosion_scene = preload("res://Scenes/fruit_explosion.tscn")

func _ready() -> void:
	original_word = WordManager.get_random_word()
	target_word = original_word
	update_label()
	
	$Sprite2D.frame = randi_range(0, 227)
	rotation_speed = randf_range(-3.0, 3.0)
	var slowdown_factor = 1.0 - (GameManager.slow_fall_level * 0.10)
	fall_speed = fall_speed * max(0.2, slowdown_factor)

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	$Sprite2D.rotation += rotation_speed * delta
	
	if position.y > get_viewport_rect().size.y:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func type_letter(letter: String) -> bool:
	if target_word.begins_with(letter):
		label.modulate = Color.WHITE 
		click.play()
		target_word = target_word.substr(1)
		update_label()
		
		if target_word == "":
			print("Fruit destroyed!")
			var base_reward = original_word.length()
			GameManager.add_juice(base_reward)
			if explosion_scene:
				var explosion = explosion_scene.instantiate()
				explosion.global_position = global_position
				get_tree().current_scene.add_child(explosion)
			
			explode.reparent(get_tree().current_scene)
			explode.play()
			explode.finished.connect(explode.queue_free)
			
			queue_free()
			
		return true 
		
	else:
		label.modulate = Color(0.957, 0.0, 0.0, 1.0)
		var tween = create_tween()
		tween.tween_property(label, "modulate", Color.WHITE, 0.15)
		return false

func update_label() -> void:
	var typed_length = original_word.length() - target_word.length()
	var typed_part = original_word.substr(0, typed_length)
	label.text = "[center][color=#116bfa]" + typed_part + "[/color]" + target_word + "[/center]"
