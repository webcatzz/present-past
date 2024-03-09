extends Node

onready var savedata = {
	"name": "June",
	"room": "test",
	"inventory": [],
	"room_vars": {
		"test:key_taken": false,
		"test:door_unlocked": false,
		"test:lights": true,
	},
	"options": {
		"volume": 100,
		"crt": false,
	}
}


func save_data():
	var file = File.new()
	file.open("res://savedata.json", File.WRITE)
	file.store_string(to_json(savedata))
	file.close()

func load_data():
	var file = File.new()
	if file.file_exists("res://savedata.json"):
		file.open("res://savedata.json", File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			savedata = data
			#setting room
			Main.switch_room(savedata["room"])
			#setting inventory
			for item in Main.InventorySeparator.get_children():
				item.queue_free()
			for item in savedata["inventory"]:
				var new_item = Main.Item.instance()
				new_item.name = item
				new_item.get_node("Label").text = item
				if ResourceLoader.exists("Assets/Items/" + item + ".png"):
					new_item.get_node("Slot/Margins/Icon").texture = load("Assets/Items/" + item + ".png")
				Main.InventorySeparator.add_child(new_item)
			#setting filter
			get_node("/root/Root/CRT").visible = Data.savedata["options"]["crt"]
			#setting volume
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(savedata["options"]["volume"] / 100))
			return "[loaded data!]"
		else:
			return "[err: unable to load, corrupted data!]"
	else:
		return "[err: no saved data.]"
