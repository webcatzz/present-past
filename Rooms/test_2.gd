extends ColorRect


func runCommand(object, action, _item):
	match object:
		"door":
			match action:
				"use":
					Main.switch_room("test")
				_:
					return "It's too dark to see anything."
		"ghost", "eyes":
			return "What?"
		"back", "return":
			Main.switch_room("test")
		_:
			return "It's too dark to see anything."
