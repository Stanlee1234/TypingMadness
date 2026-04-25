extends Node2D

var valid_words: Array = []
var api_url: String = "https://random-word-api.herokuapp.com/all"
var is_ready: bool = false

@onready var http_request: HTTPRequest = HTTPRequest.new()

signal words_loaded
signal dictionary_loaded

func _ready() -> void:
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	fetch_words_from_api()

func fetch_words_from_api() -> void:
	var error = http_request.request(api_url)
	if error != OK:
		load_local_words()
		

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		var json = JSON.new()
		var raw_text = body.get_string_from_utf8()
		var clean_text = raw_text
		var error = json.parse(clean_text)

		if error == OK:
			valid_words = json.data
			print("Loaded %d words from the API." % valid_words.size())
			words_loaded.emit()
			dictionary_loaded.emit()
			is_ready = true
		else:
			print("Failed to parse API JSON. Falling back to local dictionary.")
			load_local_words()
	else:
		print("API unreachable or offline. Falling back to local dictionary.")
		load_local_words()

func load_local_words() -> void:
	var file = FileAccess.open("res://words.txt", FileAccess.READ)
	while not file.eof_reached():
		var word = file.get_line().strip_edges().to_lower() 
		if word != "":
			valid_words.append(word)
	dictionary_loaded.emit()
	is_ready = true
	
func is_word_valid(word_to_check: String) -> bool:
	return valid_words.has(word_to_check.to_lower())

func get_random_word() -> String:
	if valid_words.is_empty():
		return "error"
		
	return valid_words.pick_random()
