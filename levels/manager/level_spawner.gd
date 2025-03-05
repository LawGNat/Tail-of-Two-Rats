extends Node

@export var level_container: Node
@export var spawn_limit = 1
@export var auto_spawn_list: Array[PackedScene]
@export var manager: Node2D

func spawn_level():
	if manager.Playroom.isHost():
		pass
		
	var level_instance = auto_spawn_list[0].instantiate()
	level_container.add_child(level_instance)
	manager.Playroom.setState("level", level_instance)
	pass
