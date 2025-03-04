extends Area2D

@onready var sprite = $Sprite2D

@export var idle_texture: Texture2D
@export var pressed_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = idle_texture

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.texture = pressed_texture

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.texture = idle_texture
