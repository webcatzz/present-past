extends Control


func _on_Slot_mouse_entered():
	$Tween.interpolate_property($Slot, "rect_position",
		Vector2(0, 11), Vector2.ZERO, 0.25,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	$Label.visible = true


func _on_Slot_mouse_exited():
	$Tween.interpolate_property($Slot, "rect_position",
		Vector2.ZERO, Vector2(0, 11), 0.5,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	$Label.visible = false
