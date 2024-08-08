extends Node2D

var camera_scene:  = preload("res://scenes/game_camera.tscn")

var game_camera: GameCamera = null

@onready var level_generator: Node2D = $LevelGenerator
@onready var player: Player = %Player

func _ready() -> void:
	game_camera = camera_scene.instantiate()
	game_camera.set_up_camera($Player)
	add_child(game_camera)
	
	if player:
		level_generator.setup(player)




func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	

