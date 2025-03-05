extends Node2D

@onready var ui = $EmoteControl
@onready var player = $Player
@onready var camera = $Camera2D
@onready var eyedropper_cursor = $EyedropMouse

var eyedropper_active = false

func _ready() -> void:
	ui.emote_selected.connect(player.set_emote)
	ui.eyedropper_mode_activated.connect(_activate_eyedropper)
	eyedropper_cursor.visible = false
	
func _physics_process(_delta):
	if eyedropper_active:
		var mouse_position = get_global_mouse_position()
		eyedropper_cursor.position = mouse_position

func _activate_eyedropper():
	eyedropper_active = true
	eyedropper_cursor.visible = true
	
func _deactivate_eyedropper():
	eyedropper_active = false
	eyedropper_cursor.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if eyedropper_active and event is InputEventMouseButton and event.pressed:
		_deactivate_eyedropper()
		var viewport_pos = event.position
		var picked_color = _sample_color_at_position(viewport_pos)
		
		if picked_color:
			player.set_color_emote(picked_color)
		
func _sample_color_at_position(screen_pos: Vector2) -> Color:
	var viewport = get_viewport()
	var texture = viewport.get_texture()
	
	if texture is ViewportTexture:
		var image = texture.get_image()
		var tex_size = image.get_size()
		
		if screen_pos.x >= 0 and screen_pos.y >= 0 and screen_pos.x < tex_size.x and screen_pos.y < tex_size.y:
			var color = image.get_pixelv(screen_pos)
			return color
			
	return Color.WHITE
