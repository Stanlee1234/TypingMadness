extends Control

@onready var master_slider = $MasterSlider
@onready var music_slider = $MusicSlider

var master_bus_idx: int
var music_bus_idx: int

func _ready() -> void:
	# Find the ID numbers for our audio buses
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	
	# Make sure the actual audio matches the 50% slider value when the screen loads
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(master_slider.value))
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(music_slider.value))

# Connect this signal from the MasterSlider Node tab
func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value))

# Connect this signal from the MusicSlider Node tab
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))
