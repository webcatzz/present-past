extends Node

onready var RoomDisplay = get_node("/root/Root/WindowMargins/WindowSeparator/RoomDisplay")
onready var CurrentRoom = RoomDisplay.get_child(0)

onready var Responder = load("res://Responder.tscn")
onready var OutputSeparator = get_node("/root/Root/WindowMargins/WindowSeparator/WindowControls/TextDisplay/TextMargins/TextSeparator/OutputDisplay/OutputSeparator")

onready var Item = load("res://Item.tscn")
onready var InventorySeparator = get_node("/root/Root/WindowMargins/WindowSeparator/WindowControls/InventoryDisplay/InventoryMargins/InventorySeparator")

onready var SFX = get_node("/root/Root/SFX")
onready var Music = get_node("/root/Root/Music")


func handle(input):
	var processed = input.to_lower().strip_edges()
	if processed.empty():
		return
	
	# response creator:
	var responder = Responder.instance()
	responder.get_child(0).text = "> " + input.strip_edges()
	var output = responder.get_child(1)
	
	# processing input variables into command:
	var action = processed.split(" ", 1)[0]
	var object = processed.split(" ", 1)[-1]
	var item
	if processed.find(" on ") != -1:
		item = processed.split(" ", 1)[-3]
		object = processed.split(" ", 1)[-1]
	
	# running command:
	var response = CurrentRoom.runCommand(object, action, item)
	if response is String:
		output.text = response
	else:
		# built-in commands:
		match action:
			"save":
				Data.save_data()
				output.text = "[data saved!]"
				output.set("custom_colors/default_color", Color("#3a3f3f"))
				play("sfx", "save")
			"load":
				output.text = Data.load_data()
				output.set("custom_colors/default_color", Color("#3a3f3f"))
				if output.text == "[loaded data!]":
					play("sfx", "save")
			"volume":
				var volume = clamp(float(object), 0, 100)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(volume / 100))
				output.text = "[volume set to " + String(volume) + ".]"
				output.set("custom_colors/default_color", Color("#3a3f3f"))
				play("sfx", "click")
				Data.savedata["options"]["volume"] = volume
			"play":
				if ResourceLoader.exists("res://Assets/Music/" + object + ".wav"):
					play("music", object)
					output.text = "[now playing: " + object + ".]"
				else:
					output.text = "[err: no such file!]"
				output.set("custom_colors/default_color", Color("#3a3f3f"))
			"stop":
				Music.stop()
				output.text = "[stopped music playback.]"
				output.set("custom_colors/default_color", Color("#3a3f3f"))
			"crt":
				get_node("/root/Root/CRT").visible = !get_node("/root/Root/CRT").visible
				output.queue_free()
				play("sfx", "click")
				Data.savedata["options"]["crt"] = !Data.savedata["options"]["crt"]
			"help":
				output.text = "examine: Action keyword for examining.\nuse: Action keyword for interacting.\ntake: Action keyword for taking.\nsave/load: Save and load data.\nvolume: Set master volume.\ncrt: Toggle crt shader."
				output.visible_characters = output.get_total_character_count()
				output.set("custom_colors/default_color", Color("#3a3f3f"))
			"intro":
				Main.switch_room("intro")
				output.queue_free()
			_:
				output.queue_free()
	
	OutputSeparator.add_child(responder)
	
	if OutputSeparator.get_child_count() > 20:
		OutputSeparator.get_child(0).queue_free()


func play(type, sound):
	match type:
		"sfx":
			SFX.stream = load("res://Assets/SFX/" + sound + ".wav")
			SFX.play()
		"music":
			Music.stream = load("res://Assets/Music/" + sound + ".wav")
			Music.play()


func switch_room(new_room):
	CurrentRoom.queue_free()
	RoomDisplay.add_child(load("res://Rooms/" + new_room + ".tscn").instance())
	CurrentRoom = RoomDisplay.get_child(1)
	Data.savedata["room"] = new_room
	#play("sfx", "move")


func add_to_inv(item):
	Data.savedata["inventory"].append(item)
	var new_item = Item.instance()
	new_item.name = item
	new_item.get_node("Label").text = item
	if ResourceLoader.exists("Assets/Items/" + item + ".png"):
		new_item.get_node("Slot/Icon").texture = load("Assets/Items/" + item + ".png")
	InventorySeparator.add_child(new_item)


func remove_from_inv(item):
	Data.savedata["inventory"].erase(item)
	InventorySeparator.get_node(item).queue_free()


func start_cutscene(name):
	toggle_input()
	switch_room("Cutscenes/" + name)


func toggle_input():
	var InputField = get_node("/root/Root/WindowMargins/WindowSeparator/WindowControls/TextDisplay/TextMargins/TextSeparator/InputSeparator/InputField")
	var InputCaret = get_node("/root/Root/WindowMargins/WindowSeparator/WindowControls/TextDisplay/TextMargins/TextSeparator/InputSeparator/InputCaret")
	InputField.editable = !InputField.editable
	if !InputField.editable:
		InputCaret.text = ":>"
	else:
		InputCaret.text = ">"


func output(text):
	var responder = Responder.instance()
	responder.get_child(0).queue_free()
	responder.get_child(1).text = text
	
	OutputSeparator.add_child(responder)
	if OutputSeparator.get_child_count() > 20:
		OutputSeparator.get_child(0).queue_free()
