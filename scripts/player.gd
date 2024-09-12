extends CharacterBody2D
class_name Player

signal died

@export var speed: = 300.0
@export var accelerometer_speed: = 130.0
@export var stop_delay: = 10
@export var gravity: = 15.0
@export var max_fall_velocity: = 1000.0
@export var jump_velocity: = 800.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var sprite_2d: Sprite2D = %Sprite2D

var dead: = false
var viewport_size

var use_accelerometer: = false

var fall_anim_name: = "fall"
var jump_anim_name: = "jump"

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
	if OS.get_name() == 'Android' or OS.get_name() == 'iOS':
		use_accelerometer = true
	
	



func _process(_delta: float) -> void:
	if velocity.y > 0:
		if animation_player.current_animation != fall_anim_name:
			animation_player.play(fall_anim_name)
	else:
		if animation_player.current_animation != jump_anim_name:
			animation_player.play(jump_anim_name)


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
	
	if !dead:
		if use_accelerometer:
			var mobile_input = Input.get_accelerometer()
			velocity.x = mobile_input.x * accelerometer_speed
		else:
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
	SoundFx.play("jump")
	MyUtility.add_log_message("player_jumped")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()


func die():
	if !dead:
		collision_shape_2d.set_deferred("disabled", true)
		SoundFx.play("fall")
		died.emit()
		dead = true


func use_new_skin() -> void:
	fall_anim_name = "fall_red"
	jump_anim_name = "jump_red"
	
	if sprite_2d:
		sprite_2d.texture = preload("res://assets/textures/character/Skin2Idle.png")
	
