extends Area2D

var fall_speed: float = 100.0 
var rotation_speed: float = 0.0
var original_word: String = ""
var target_word: String = "" 

@onready var label = $Label
@onready var explode = $Explode
var explosion_scene = preload("res://Scenes/fruit_explosion.tscn")


func _ready() -> void:
	original_word = WordManager.get_random_word()
	target_word = original_word
	label.text = target_word
	$Sprite2D.frame = randi_range(0, 227)
	rotation_speed = randf_range(-3.0, 3.0)

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	$Sprite2D.rotation += rotation_speed * delta
	
	if position.y > 680:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func type_letter(letter: String) -> bool:
	if target_word.begins_with(letter):
		target_word = target_word.substr(1)
		label.text = target_word
		if target_word == "":
			print("Fruit destroyed!")
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
		return false 
