extends Resource
class_name Target


@export var names: PackedStringArray
@export var sfx: String
@export_multiline var description: String


func affect(action: String, item: String):
	if action == "info":
		global.get_ui().print_to_log(description)
		if !sfx.is_empty(): global.play_sfx(sfx)
	else:
		on_action(action, item)


func on_action(action: String, item: String):
	pass
