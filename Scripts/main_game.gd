extends Control

@onready var terminal_input = $TerminalInput

func _ready() -> void:
	# This automatically puts the blinking cursor in the box 
	# so the player doesn't have to click it with their mouse!
	terminal_input.grab_focus()

func _on_terminal_input_text_submitted(new_text: String) -> void:
	if WordManager.is_word_valid(new_text):
		print("ACCESS GRANTED: '" + new_text + "' is a valid code.")
	else:
		print("SYSTEM ERROR: '" + new_text + "' rejected.")
	terminal_input.clear()
