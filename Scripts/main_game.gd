extends Control

@onready var terminal_input = $TerminalInput

func _ready() -> void:
	terminal_input.editable = false
	terminal_input.placeholder_text = "Establishing Connection..."
	WordManager.dictionary_loaded.connect(_on_dictionary_loaded)

func _on_dictionary_loaded() -> void:
	terminal_input.editable = true
	terminal_input.placeholder_text = "Enter override code..."
	terminal_input.grab_focus()

func _on_terminal_input_text_submitted(new_text: String) -> void:
	if WordManager.is_word_valid(new_text):
		print("ACCESS GRANTED: '" + new_text + "' is a valid code.")
	else:
		print("SYSTEM ERROR: '" + new_text + "' rejected.")
	terminal_input.clear()
