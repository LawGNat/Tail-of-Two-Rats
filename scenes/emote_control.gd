extends Control

signal emote_selected(emote_name: String)
signal eyedropper_mode_activated()

func _on_checkmark_button_pressed() -> void:
	emit_signal("emote_selected", "checkmark")

func _on_x_mark_button_pressed() -> void:
	emit_signal("emote_selected", "xmark")

func _on_eyedrop_button_pressed() -> void:
	emit_signal("eyedropper_mode_activated")
