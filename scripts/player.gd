extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 30.0

@onready var animation = $AnimatedSprite2D

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if velocity.is_zero_approx():
		animation.play("idle")
	else:
		animation.play("running")
	
	if input_direction.length() > 0:
		var target_angle = input_direction.angle() + PI / 2
		rotation = lerp_angle(rotation, target_angle, rotation_speed * get_process_delta_time())

func _physics_process(_delta):
	get_input()
	move_and_slide()
