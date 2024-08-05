extends Camera2D
class_name GameCamera
var player: Player = null
var viewport_size: Vector2

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x * 0.5
	
	limit_bottom = viewport_size.y
	limit_left = 0
	limit_right = viewport_size.x


func _process(_delta: float) -> void:
	if player:
		var limit_distance: = 420.0
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = player.global_position.y + limit_distance


func _physics_process(_delta: float) -> void:
	if player:
		global_position.y = player.global_position.y


func set_up_camera(_player: Player):
	if _player:
		player = _player
