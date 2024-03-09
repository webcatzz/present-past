extends VisibleTarget
class_name Pickup


@export var item: String


func on_action(action: String, _item):
	if action == "take" and visible:
		visible = false
		global.data.add_item(item)
