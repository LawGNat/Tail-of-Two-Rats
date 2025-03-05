extends Control

@export var emote_textures: Dictionary = {
	"checkmark": preload("res://assets/sprites/ui/sendcheck1.png"),
	"xmark": preload("res://assets/sprites/ui/sendcheck2.png"),
	"eyedropper": preload("res://assets/sprites/ui/sendcheck3.png")
}

@export var duration = 2.0

@onready var texture_rect = $ThoughtBubbleSprite

func _ready() -> void:
	texture_rect.texture = null

func _process(_delta):
	rotation = -get_parent().rotation

func set_emote(emote_name: String):
	if emote_textures.has(emote_name):
		texture_rect.texture = emote_textures[emote_name]
		await get_tree().create_timer(duration).timeout
		texture_rect.texture = null
	
func set_color_emote(selected_color: Color):
	set_emote("eyedropper")
	texture_rect.modulate = selected_color
