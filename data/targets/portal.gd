extends Target
class_name Portal


@export_group("Portal")
@export var destination: String


func on_action(action: String, _item):
	if action == "move":
		global.switch_room(destination)
