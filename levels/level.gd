extends Node2D



@export var player_rat: Array[PackedScene]
@export var player_spawner: Node2D
@export var spawn_points: Array[Node2D]

var sync_objs = []

@onready var player_scene = "res://player/player.tscn"

var Playroom = JavaScriptBridge.get_interface("Playroom")
var jsBridgeReferences = []


func bridgeToJS(cb):
	var jsCallback = JavaScriptBridge.create_callback(cb)
	jsBridgeReferences.push_back(jsCallback)
	return jsCallback

var next_spawn_point_index = 0


func _ready():
	if not Playroom.isHost():
		print("Client")
		print("Player scene path:", player_scene)
		print("Spawn points:", spawn_points)
		print("First spawn point:", spawn_points[0])
		print("Second spawn point:", spawn_points[1])
		for sp in spawn_points:
			print(sp, sp.global_position)
		spawn(player_scene, spawn_points[1].global_position.x, spawn_points[1].global_position.y)
	else:
		print("Host")
		print("Player scene path:", player_scene)
		print("Spawn points:", spawn_points)
		print("First spawn point:", spawn_points[0])
		print("Second spawn point:", spawn_points[1])
		for sp in spawn_points:
			print(sp, sp.global_position)
		spawn(player_scene, spawn_points[0].global_position.x, spawn_points[0].global_position.y)

func spawn(object : String, posx : int, posy : int):
	print("Spawning player at:", posx, posy)  # Debugging line
	var pos = Vector2(posx,posy)
	var obj = load(object)
	print("Loaded object:", obj)
	if obj == null:
		print("Failed to load player scene:", object)
		return
	var inst = obj.instantiate()
	add_child(inst)
	#var rng = RandomNumberGenerator.new()
	#inst.name = idgen(10)
	inst.global_position.x = pos.x
	inst.global_position.y = pos.y
	sync_objs.append([inst.name,object,posx,posy])
	Playroom.setState("objs",str(sync_objs))
	return inst
	
