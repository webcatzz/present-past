extends Control


func set_item(item: String):
	$Panel/Card/Sprite.texture = load("res://assets/items/" + item + ".png")
	$Label.text = item


func on_mouseover(hovered: bool):
	var tween = create_tween().set_trans(Tween.TRANS_EXPO if hovered else Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property($Panel/Card, "position", Vector2.ZERO if hovered else Vector2(0, 12), 0.2 if hovered else 0.5)
	tween.parallel().tween_property($Label, "modulate:a", 1 if hovered else 0, 0.2)
