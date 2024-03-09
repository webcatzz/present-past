extends TextureRect

var lights = true


func _ready():
	if Data.savedata["room_vars"]["test:door_unlocked"]:
		$Door.visible = false
		$Lights/Eyes.visible = true
	if Data.savedata["room_vars"]["test:key_taken"]:
		$Lights/Key.visible = false
	if !Data.savedata["room_vars"]["test:lights"]:
		$Lights.visible = true
		lights = false


func runCommand(object, action, item):
	match object:
		"fireplace", "fire", "hearth":
			match action:
				"examine":
					return "The embers are still warm... someone's been here. Recently."
				"use":
					return "You poke the ashes. Nothing happens."
		"lightswitch", "lights", "switch":
			match action:
				"examine":
					return "It's a lightswitch. You can turn it on and off."
				"use":
					Main.play("sfx", "click")
					if lights:
						$Lights.visible = true
						lights = false
						Data.savedata["room_vars"]["test:lights"] = false
						if !Data.savedata["room_vars"]["test:key_taken"]:
							return "You turn the lights off. Hey, there's something glimmering on the floor!"
						return "You turn the lights off."
					else:
						$Lights.visible = false
						lights = true
						Data.savedata["room_vars"]["test:lights"] = true
						return "You turn the lights back on."
		"door":
			if Data.savedata["room_vars"]["test:door_unlocked"]:
				if !lights:
					Main.start_cutscene("ghost_1")
				else:
					match action:
						"examine":
							return "It's too dark to see anything."
						"use":
							Main.switch_room("test_2")
			else:
				if item == "key":
					if Data.savedata["inventory"].has("test_key"):
						if lights:
							Main.remove_from_inv("test_key")
							Data.savedata["room_vars"]["test:door_unlocked"] = true
							$Door.visible = false
							Main.play("sfx", "click")
							$Lights/Eyes.visible = true
							return "Fit like a glove! Or maybe like a key in a lock."
						else:
							return "Better turn the lights on first."
					else:
						return "You don't have a key."
				else:
					return "It's locked."
		"floor", "shiny":
			if !Data.savedata["room_vars"]["test:key_taken"] and !lights:
				match action:
					"examine":
						return "There's a key glimmering on the floor."
		"key":
			if !Data.savedata["room_vars"]["test:key_taken"] and !lights:
				match action:
					"examine":
						return "It's a key."
					"take":
						Data.savedata["room_vars"]["test:key_taken"] = true
						Main.add_to_inv("test_key")
						Main.play("sfx", "click")
						$Lights/Key.visible = false
