extends CanvasLayer

@onready var console_log: Control = $Debug/ConsoleLog


func _ready() -> void:
	console_log.visible = false


func _process(_delta: float) -> void:
	pass


func _on_texture_button_toggled(toggled_on: bool) -> void:
	console_log.visible = toggled_on
