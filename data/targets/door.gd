extends VisibleTarget
class_name Door


@export_group("Door")
@export var key_id: String
@export var locked: bool
@export var destination: String


func on_action(action: String, item: String):
	if global.data.flags.has("key_" + key_id + "_used"): locked = false
	
	if action == "move" or action == "use" and item != "key":
		if locked:
			global.get_ui().print_to_log(["It's locked.", "Can't open that.", "Firmly closed.", "Seems locked."].pick_random())
		else:
			global.switch_room(destination)
	elif action in ["open", "unlock"] or item == "key":
		if key_id in global.data.inventory:
			global.data.remove_item(key_id)
			global.data.flags.append("key_" + key_id + "_used")
			locked = false
			if frames.size() > 0:
				play_animation()
			else:
				visible = false
				global.play_sfx(sfx)
		else:
			global.get_ui().print_to_log("You don't have the key.", Output.ERROR)
