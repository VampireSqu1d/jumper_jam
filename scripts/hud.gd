extends Control

signal pause_game

@onready var top_bar_bg: ColorRect = $TopBarBg
@onready var top_bar: Control = $TopBar
@onready var score_label: Label = $TopBar/ScoreLabel

@export var margin: = 10

var window_height: = 960.0
var window_width: = 540.0

func _ready() -> void:
	var os_name = OS.get_name()
	if os_name == 'Android' || os_name == 'iOS':
		var safe_area: = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		
		if os_name == "iOS":
			top_bar.position.y += (safe_area_top / DisplayServer.screen_get_scale())
			top_bar_bg.size.y += ((safe_area_top + margin) / DisplayServer.screen_get_scale())
		else:
			var window_scale: = DisplayServer.window_get_size().y / window_height
			top_bar.position.y += (safe_area_top / window_scale)
			top_bar_bg.size.y += (safe_area_top + margin) / window_scale
		
		
		
		MyUtility.add_log_message("Safe area: " + str(safe_area))
		MyUtility.add_log_message("Window size: " + str(DisplayServer.window_get_size()))
		MyUtility.add_log_message("safe area pos: " + str(safe_area_top))
		MyUtility.add_log_message("top bar pos: " + str(top_bar.position))


func set_score(new_score: int):
	score_label.text = str(new_score)


func _on_pause_button_pressed() -> void:
	SoundFx.play("click")
	pause_game.emit()#get_tree().paused = !get_tree().paused
