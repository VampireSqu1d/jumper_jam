extends Node2D

@export var player_spawn_pos_y_offset = 135
@onready var ground_sprite_2d: Sprite2D = $GroundSprite2D
@onready var level_generator: Node2D = $LevelGenerator
@onready var parallax_layer: Parallax2D = $ParallaxBackground/ParallaxLayer
@onready var parallax_layer_2: Parallax2D = $ParallaxBackground/ParallaxLayer2
@onready var parallax_layer_3: Parallax2D = $ParallaxBackground/ParallaxLayer3

var camera_scene:  = preload("res://scenes/game_camera.tscn")
var game_camera: GameCamera = null

var player_scene: = preload("res://scenes/player.tscn")
var player: Player  = null
var player_spawn_pos: Vector2

var viewport_size: Vector2

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
	player_spawn_pos.x = viewport_size.x * 0.5
	player_spawn_pos.y = viewport_size.y - player_spawn_pos_y_offset
	
	ground_sprite_2d.global_position.x = viewport_size.x * 0.5
	ground_sprite_2d.global_position.y = viewport_size.y
	
	setup_parallax_layer(parallax_layer)
	setup_parallax_layer(parallax_layer_2)
	setup_parallax_layer(parallax_layer_3)
	
	new_game()


func get_parallax_sprite_scale(sprite: Sprite2D) -> Vector2:
	var parallax_texture = sprite.get_texture()
	var parallax_scale = viewport_size.x / parallax_texture.get_width()
	
	return Vector2(parallax_scale, parallax_scale)


func setup_parallax_layer(layer: Parallax2D):
	var sprite = layer.find_child("Sprite2D")
	if sprite:
		sprite.scale = get_parallax_sprite_scale(sprite)
		var my = sprite.scale.y * sprite.get_texture().get_height()
		layer.repeat_size.y = my


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)
	if Input.is_action_just_pressed("reset"):
		get_tree().call_deferred("reload_current_scene")


func new_game():
	player = player_scene.instantiate()
	player.global_position = player_spawn_pos
	call_deferred("add_child", player)
	
	game_camera = camera_scene.instantiate()
	game_camera.call_deferred("set_up_camera", player)#.set_up_camera($Player)
	call_deferred("add_child", game_camera)
	
	if player:
		level_generator.setup(player)
