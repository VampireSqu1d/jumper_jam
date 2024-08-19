extends Control

@export var fade_in_duration: = 0.5
@export var fade_out_duration: = 0.5

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
	get_tree().call_group("buttons", "set_disabled", true)


func appear():
	visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, fade_in_duration)
	return tween


func disappear():
	get_tree().call_group("buttons", "set_disabled", true)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, fade_out_duration)
	visible = false
	return tween
