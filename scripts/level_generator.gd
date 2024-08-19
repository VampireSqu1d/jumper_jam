extends Node2D

@export var y_distance_between_plaforms: = 100.0
@export var level_size: = 50
@onready var platform_container: Node2D = %PlatformContainer

var platform_scene: = preload("res://scenes/platform.tscn")
#level gen vars
var start_platform_y

var viewport_size: Vector2
var platform_width: = 136.0
var plaform_height: = 120.0
var generated_plaform_count: = 0
var player: Player = null

func setup(_player: Player):
	if _player:
		player = _player


func _ready() -> void:
	generated_plaform_count = 0
	viewport_size = get_viewport_rect().size
	start_platform_y = viewport_size.y - (y_distance_between_plaforms * 2)


func start_generation() -> void:
	generate_level(start_platform_y, true)


func _process(_delta: float) -> void:
	if player:
		var py = player.global_position.y
		var end_of_level_pos = start_platform_y - (generated_plaform_count * y_distance_between_plaforms)
		var threshold = end_of_level_pos + (y_distance_between_plaforms * 6)
		if py <= threshold:
			generate_level(end_of_level_pos, false)


func generate_ground():
	var ground_layer_plaform_count = (viewport_size.x / platform_width) + 1
	
	for i in range(ground_layer_plaform_count):
		var ground_location= Vector2(i * platform_width, viewport_size.y - plaform_height)
		
		create_platform(ground_location)


func create_platform(location: Vector2) -> Platform:
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_container.call_deferred("add_child", platform)
	return platform


func generate_level(start_y: float, should_generate_ground: bool = false):
	if should_generate_ground:
		call_deferred("generate_ground")
	
	#gernerate the level
	for i in range(level_size):
		var location: Vector2 = Vector2.ZERO
		var max_x_pos =  viewport_size.x - platform_width
		var random_x = randf_range(0.0, max_x_pos)
		location.x = random_x
		location.y = start_y - (y_distance_between_plaforms * i)
		
		create_platform(location)
		generated_plaform_count += 1
