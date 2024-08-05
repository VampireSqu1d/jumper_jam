extends CharacterBody2D
class_name Player

@export var speed: = 300.0
@export var stop_delay: = 10
@export var gravity: = 15.0
@export var max_fall_velocity: = 1000.0
@export var jump_velocity: = 800.0
@onready var animation_player: AnimationPlayer = %AnimationPlayer


var viewport_size
func _ready() -> void:
	viewport_size = get_viewport_rect().size


func _process(_delta: float) -> void:
	if velocity.y > 0:
		if animation_player.current_animation != "fall":
			animation_player.play("fall")
	else:
		if animation_player.current_animation != "jump":
			animation_player.play("jump")


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
	
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed/ 10)
	
	
	move_and_slide()
	
	var margin: = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = 0 - margin
	elif global_position.x < 0 - margin:
		global_position.x = viewport_size.x + margin


func jump():
	velocity.y = jump_velocity * -1
