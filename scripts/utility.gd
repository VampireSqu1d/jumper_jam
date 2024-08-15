extends Node


func add_log_message(log_message: String):
	var console: Control = get_tree().get_first_node_in_group("debug_console")
	if console:
		var log_label: Label = console.find_child("LogLabel")
		if log_label:
			log_label.text += log_message + "\n"
