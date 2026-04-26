extends Node

var valid_words: Array = []
var is_ready: bool = false

signal words_loaded
signal dictionary_loaded

func _ready() -> void:
	print("Loading local dictionary...")
	load_local_words()

func load_local_words() -> void:
	valid_words.clear()
	var file = FileAccess.open("res://Texts/words.txt", FileAccess.READ)
	
	if file:
		while not file.eof_reached():
			var word = file.get_line().strip_edges().to_lower()
			if word != "":
				valid_words.append(word)
		file.close()
		is_ready = true
		dictionary_loaded.emit()
		
		print("Loaded %d words from the local file." % valid_words.size())
	else:
		print("ERROR: Could not find res://words.txt!")

func is_word_valid(word_to_check: String) -> bool:
	return valid_words.has(word_to_check.to_lower())

func get_random_word() -> String:
	if valid_words.is_empty():
		return "error"
	return valid_words.pick_random()
