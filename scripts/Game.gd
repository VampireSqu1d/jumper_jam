extends Node2D

var camera_scene:  = preload("res://scenes/game_camera.tscn")
var platform_scene: = preload("res://scenes/platform.tscn")
var game_camera: GameCamera = null

@onready var platform_container: Node2D = %PlatformContainer

func _ready() -> void:
	game_camera = camera_scene.instantiate()
	game_camera.set_up_camera($Player)
	add_child(game_camera)
	
	generate_ground()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func generate_ground():
	var viewport_size: = get_viewport_rect().size
	var platform_width: = 136.0
	var plaform_height: = 120.0
	var ground_layer_plaform_count = (viewport_size.x / platform_width) + 1
	
	for i in range(ground_layer_plaform_count):
		var ground_location= Vector2(i * platform_width, viewport_size.y - plaform_height)
		
		create_platform(ground_location)


func create_platform(location: Vector2) -> Platform:
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_container.add_child(platform)
	return platform

