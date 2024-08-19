extends Camera2D
class_name GameCamera

@onready var destroyer: Area2D = %Destroyer
@onready var collision_shape_2d: CollisionShape2D = $Destroyer/CollisionShape2D



var player: Player = null
var viewport_size: Vector2

func _ready() -> void:
	if player:
		global_position.y = player.global_position.y
	
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x * 0.5
	
	limit_bottom = int(viewport_size.y)
	limit_left = 0
	limit_right = int(viewport_size.x)
	
	destroyer.position.y = viewport_size.y
	
	var rect_shape: = RectangleShape2D.new()
	
	var rect_shape_size: = Vector2(viewport_size.x, 100)
	rect_shape.call_deferred("set_size", rect_shape_size)#.set_size(rect_shape_size)
	collision_shape_2d.shape = rect_shape


func _process(_delta: float) -> void:
	if player:
		var limit_distance: = 420.0
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = int(player.global_position.y + limit_distance)
	
	
	var overlaping_areas = destroyer.get_overlapping_areas()
	if overlaping_areas.size() > 0:
		for area in overlaping_areas:
			if area is Platform:
				area.call_deferred("queue_free")

func _physics_process(_delta: float) -> void:
	if player:
		global_position.y = player.global_position.y


func set_up_camera(_player: Player):
	if _player:
		player = _player
