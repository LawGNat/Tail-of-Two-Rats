extends Area2D

var just_received_box = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("box") && !just_received_box:
		body.queue_free()
