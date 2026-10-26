extends SceneTree

# Run with: godot --headless --path . --script tests/settings_volume_test.gd
func _initialize() -> void:
	call_deferred("run_test")

func run_test() -> void:
	var settings = load("res://Scenes/settings.tscn").instantiate()
	root.add_child(settings)
	await process_frame
	for bus_name in ["Master", "Music"]:
		var slider = settings.get_node(bus_name + "Slider")
		var bus = AudioServer.get_bus_index(bus_name)
		if bus < 0:
			push_error("missing audio bus: " + bus_name)
			quit(1)
			return
		slider.value = 0.25
		if not is_equal_approx(AudioServer.get_bus_volume_db(bus), linear_to_db(0.25)):
			push_error(bus_name + " slider did not update its audio bus")
			quit(1)
			return
	settings.queue_free()
	await process_frame
	print("settings volume signals: pass")
	quit(0)
