extends Resource


signal item_added
signal item_removed
signal item_replaced

@export var name: String
@export var room: String = "traincar": set = on_room_changed
@export var last_room: String
@export var inventory: PackedStringArray = ["housekey"]
@export var flags: PackedStringArray:
	set(value):
		flags = value
		print(value)

@export_group("Settings")
@export_range(0, 100) var master_volume: int = 100
@export_range(0, 100) var music_volume: int = 100
@export_range(0, 100) var sfx_volume: int = 100


func add_item(item: String):
	inventory.append(item)
	emit_signal("item_added", item)


func remove_item(item: String):
	var idx: int = inventory.find(item)
	inventory.remove_at(idx)
	emit_signal("item_removed", idx)


func replace_item(old_item: String, new_item: String):
	var idx: int = inventory.find(old_item)
	inventory.set(idx, new_item)
	emit_signal("item_replaced", idx, new_item)


# tutorial

func on_room_changed(value: String):
	room = value
	
	if room == "traincar":
		global.get_ui().print_to_log('Enter "examine desk" to take a closer look at the table.', Output.TUTORIAL)
		await global.wait(2)
		global.get_ui().print_to_log('Synonyms like "look at" or "desk" will also work.', Output.TUTORIAL)
	elif room == "traincar_desk":
		pass
