extends CharacterBody2D

@export var player_id: int = 1
@export var speed = 400
@export var rotation_speed = 30.0
@export var push_force = 50.0
@export var friction = 0.9
@export var player_1_frames: SpriteFrames
@export var player_2_frames: SpriteFrames

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
	var collision = move_and_collide(velocity * _delta)
	if collision:
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var push_direction = velocity.normalized()
			
			collider.linear_velocity = push_direction * push_force
			
			if collider.linear_velocity.length() > 0:
				collider.linear_velocity *= friction
			else:
				collider.linear_velocity = collider.linear_velocity.move_toward(Vector2.ZERO, friction)
				
			collider.linear_damp = 3
			
func _ready() -> void:
	if player_id == 1:
		animation.sprite_frames = player_1_frames
	else:
		animation.sprite_frames = player_2_frames

func set_emote(emote_name: String):
	$ThoughtBubble.set_emote(emote_name)

func set_color_emote(selected_color: Color):
	$ThoughtBubble.set_color_emote(selected_color)
