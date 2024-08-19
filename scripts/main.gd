extends Node

@onready var game: Node2D = $Game
@onready var screens: CanvasLayer = $Screens


func _ready() -> void:
	screens.start_game.connect(_on_screens_start_game)


func _process(_delta: float) -> void:
	pass


func _on_screens_start_game() -> void:
	game.new_game()
