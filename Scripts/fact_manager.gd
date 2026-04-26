extends Node

var current_fact: String = "No facts for you. (For now)"
var all_facts: Array = []

func _ready():
	print("Loading local facts...")
	load_local_facts()
	fetch_new_fact()

func load_local_facts() -> void:
	var file = FileAccess.open("res://Texts/facts.json", FileAccess.READ)
	
	if file:
		var json_string = file.get_as_text()
		file.close()
		var json_data = JSON.parse_string(json_string)
		if typeof(json_data) == TYPE_DICTIONARY and json_data.has("facts"):
			all_facts = json_data["facts"]
			print("Loaded %d facts from local JSON." % all_facts.size())
		else:
			print("ERROR: facts.json is not formatted with a 'facts' array!")
	else:
		print("ERROR: Could not find res://Texts/facts.json!")

func fetch_new_fact() -> void:
	if all_facts.is_empty():
		current_fact = "Did you know? You forgot to put facts in facts.json!"
		return
		
	var random_item = all_facts.pick_random()
	
	if typeof(random_item) == TYPE_DICTIONARY and random_item.has("text"):
		current_fact = "Did you know? " + random_item["text"]
		
	elif typeof(random_item) == TYPE_STRING:
		current_fact = "Did you know? " + random_item
