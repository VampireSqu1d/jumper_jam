extends Node2D

signal player_died(score, highscore)
signal pause_game

@export var player_spawn_pos_y_offset = 135
@onready var ground_sprite_2d: Sprite2D = $GroundSprite2D
@onready var level_generator: Node2D = $LevelGenerator
@onready var parallax_layer: Parallax2D = $ParallaxBackground/ParallaxLayer
@onready var parallax_layer_2: Parallax2D = $ParallaxBackground/ParallaxLayer2
@onready var parallax_layer_3: Parallax2D = $ParallaxBackground/ParallaxLayer3
@onready var hud: Control = $UILayer/HUD


var camera_scene:  = preload("res://scenes/game_camera.tscn")
var game_camera: GameCamera = null

var player_scene: = preload("res://scenes/player.tscn")
var player: Player  = null
var player_spawn_pos: Vector2

var viewport_size: Vector2

var score: int = 0
var highscore: int = 0
var safe_file_path = "user://highscore.save"

func _ready() -> void:
	load_score()
	viewport_size = get_viewport_rect().size
	
	player_spawn_pos.x = viewport_size.x * 0.5
	player_spawn_pos.y = viewport_size.y - player_spawn_pos_y_offset
	
	
	ground_sprite_2d.global_position.x = viewport_size.x * 0.5
	ground_sprite_2d.global_position.y = viewport_size.y - 50.0
	
	setup_parallax_layer(parallax_layer)
	setup_parallax_layer(parallax_layer_2)
	setup_parallax_layer(parallax_layer_3)
	
	hud.pause_game.connect(_on_hud_pause_game)
	hud.visible = false
	hud.set_score(0)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)
	if Input.is_action_just_pressed("reset"):
		get_tree().call_deferred("reload_current_scene")
	
	if player:
		if score < int(viewport_size.y - player.global_position.y):
			score = int(viewport_size.y - player.global_position.y)
			hud.set_score(score)


#region parallax bg

func get_parallax_sprite_scale(sprite: Sprite2D) -> Vector2:
	var parallax_texture = sprite.get_texture()
	var parallax_scale = viewport_size.x / parallax_texture.get_width()
	
	return Vector2(parallax_scale, parallax_scale)


func setup_parallax_layer(layer: Parallax2D) ->  void:
	var sprite = layer.find_child("Sprite2D")
	if sprite:
		sprite.scale = get_parallax_sprite_scale(sprite)
		var my = sprite.scale.y * sprite.get_texture().get_height()
		layer.repeat_size.y = my

#endregion parallax bg

#region new game/ reset game

func new_game() -> void:
	reset_game()
	
	score = 0
	hud.visible = true
	player = player_scene.instantiate()
	player.died.connect(_on_player_died)
	player.global_position = player_spawn_pos
	call_deferred("add_child", player)
	
	game_camera = camera_scene.instantiate()
	game_camera.call_deferred("set_up_camera", player)#.set_up_camera($Player)
	call_deferred("add_child", game_camera)
	
	if player:
		level_generator.setup(player)
		level_generator.start_generation()


func reset_game() -> void:
	level_generator.reset_level()
	hud.set_score(0)
	hud.visible = false
	if player:
		player.queue_free()
		player = null
		level_generator.player = null
	if game_camera:
		game_camera.queue_free()
		game_camera = null


func _on_player_died() -> void:
	hud.visible = false
	
	if score > highscore:
		highscore = score
		print("New highscore: " + str(highscore))
		save_highscore(highscore)
		
	player_died.emit(score, highscore)

#endregion new game/ reset game

#region saving/ loading scores

func save_highscore(score_to_save) -> void:
	var file = FileAccess.open(safe_file_path, FileAccess.WRITE)
	file.store_var(score_to_save)
	MyUtility.add_log_message("saving highscore to disk")
	file.close()


func load_score() -> void:
	if FileAccess.file_exists(safe_file_path):
		var file = FileAccess.open(safe_file_path, FileAccess.READ)
		highscore = file.get_var()
		MyUtility.add_log_message("retrieving highscore from disk")
		file.close()
	else:
		MyUtility.add_log_message("no highscore save file found")
		highscore = 0

#endregion saving/ loading scores


func _on_hud_pause_game() -> void:
	pause_game.emit()
	
