extends Node2D


@export var level_container: Node
@export var level_scene: PackedScene

@export var test_label: Label

var players = []
var player_counter = 0

#Fetch Playroom
var Playroom = JavaScriptBridge.get_interface("Playroom")
# Keep a reference to the callback so it doesn't get garbage collected
var jsBridgeReferences = []


func bridgeToJS(cb):
	var jsCallback = JavaScriptBridge.create_callback(cb)
	jsBridgeReferences.push_back(jsCallback)
	return jsCallback
 
func _ready():
	JavaScriptBridge.eval("")
	var initOptions = JavaScriptBridge.create_object("Object");
 
	#Init Options
	initOptions.gameId = "<YOUR GAME ID>"
 
	#Insert Coin
	Playroom.insertCoin(initOptions, bridgeToJS(onInsertCoin));
 
# Called when the host has started the game
func onInsertCoin(args):
	#print("Coin Inserted!")
	Playroom.onPlayerJoin(bridgeToJS(onPlayerJoin))
	
	change_level.call_deferred(level_scene)
 
# Called when a new player joins the game
func onPlayerJoin(args):
	var state = args[0]
	
	if Playroom.isHost():
		state.id = player_counter
		player_counter += 1
		
		players.append(state)
		print("Player ID assigned: ", state.id)
	#print("new player joined: ", state.id)
	 
		# Listen to onQuit event
		state.onQuit(bridgeToJS(onPlayerQuit))
		
		Playroom.setState("players", players)
	else:
		print("Player joined, but this is a client not the host")
	 
func onPlayerQuit(args):
	var state = args[0];
	print("player quit: ", state.id)

func change_level(scene):
	for level in level_container.get_children():
		level_container.remove_child(level)
		level.queue_free()
	
	var new_level = scene.instantiate()
	level_container.add_child(new_level)

func _spawn_players():
	pass
	
