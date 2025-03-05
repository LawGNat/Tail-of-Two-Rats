extends Area2D

@onready var sprite = $Sprite2D

@export var idle_texture: Texture2D
@export var pressed_texture: Texture2D

@export var tilemap: TileMapLayer = null
@export var tile_layer: int = 0

var removed_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = idle_texture
	tilemap = find_sibling_tilemap()
	
func find_sibling_tilemap() -> TileMapLayer:
	var parent = get_parent()
	if parent:
		for child in parent.get_children():
			if child is TileMapLayer:
				return child
	return null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.texture = pressed_texture
		remove_blue_walls()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.texture = idle_texture
		restore_blue_walls()

func remove_blue_walls():
	var used_cells = tilemap.get_used_cells()
	removed_tiles.clear()
	
	for cell in used_cells:
		var tile_id = tilemap.get_cell_source_id(cell)
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data and tile_data.get_custom_data("type") == "blue_wall":
			removed_tiles.append({"position": cell, "tile_id": tile_id})
			tilemap.set_cell(cell, -1, Vector2i(0, 0), 0)
			print(tilemap.get_cell_source_id(cell))
			
func restore_blue_walls():
	for tile in removed_tiles:
		var tile_position = tile["position"]
		var tile_id = tile["tile_id"]
		tilemap.set_cell(Vector2(tile_position.x, tile_position.y), tile_id, Vector2i(0, 0), 0)
	removed_tiles.clear()
