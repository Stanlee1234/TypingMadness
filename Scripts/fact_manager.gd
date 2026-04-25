extends Node

var current_fact: String = "Offline - No facts loadable"
var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	fetch_new_fact()

func fetch_new_fact():
	var error = http_request.request("https://uselessfacts.jsph.pl/api/v2/facts/random")
	if error != OK:
		print("An error occurred in the HTTP request.")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var json_data = JSON.parse_string(body_string)
		if json_data and typeof(json_data) == TYPE_DICTIONARY:
			if json_data.has("text"):
				current_fact = json_data["text"]
			else:
				print("JSON parsed, but 'text' key is missing.")
		else:
			print("Failed to parse JSON string.")
