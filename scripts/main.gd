extends Node

@onready var game: Node2D = $Game
@onready var screens: CanvasLayer = $Screens


func _ready() -> void:
	screens.start_game.connect(_on_screens_start_game)
	screens.delete_level.connect(_on_screens_delete_level)
	game.player_died.connect(_on_game_player_died)

func _process(_delta: float) -> void:
	pass


func _on_screens_start_game() -> void:
	game.new_game()


func _on_screens_delete_level() -> void:
	game.reset_game()


func _on_game_player_died(score: int, highscore: int) -> void:
	screens.game_over(score, highscore)
