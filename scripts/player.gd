extends CharacterBody2D

@export var speed: = 300.0
@export var stop_delay: = 10

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed/ 10)
	
	
	move_and_slide()
