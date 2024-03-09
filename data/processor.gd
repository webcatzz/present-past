extends Node

# go through the door
# go left
# enter the left door
# open the vent
# open box
# examine lock
# look at lock
# look up
# pick the lock
# pick up the book
# use key on lock
# slam book on desk
# unlock lock with key
# go up to house

# structure variations:
# [ACTION] + [TARGET]
# [ACT, ION] + [TAR, GET]
# [ACTION] + [ARTICLE] + [TARGET]
# [ACTION] + [ITEM] + ON + [TARGET]
# [ACTION] + [TARGET] + WITH + [ITEM]
# [ACTION] + [ARTICLE] + [ITEM] + ON + [TARGET]
# [ACTION] + [ARTICLE] + [TARGET] + WITH + [ITEM]

# [ACTION] + (PREPOSITIONS) + (ARTICLE) + [TARGET]
# [ACTION] + (PREPOSITIONS) + (ARTICLE) + [TARGET] + WITH + (ARTICLE) + [ITEM]
# [ACTION] + (PREPOSITIONS) + (ARTICLE) + [ITEM] + ON + (ARTICLE) + [TARGET]
# [ACTION] + (PREPOSITIONS) + (ARTICLE) + [TAR, GET]

func process(text: String):
	if text == "back": # global back action
		global.switch_room(global.data.last_room)
		return
	
	# splitting text:
	var input: PackedStringArray = text.split(" ", false)
	if input.size() <= 1: return
	
	# grabbing action & filtering action synonyms:
	var action: String = input[0]
	if action in ["look", "examine"]: action = "info"
	elif action in ["move", "go", "approach", "walk", "stroll", "run", "enter"]: action = "move"
	elif action in ["take", "pick", "grab", "collect", "grab", "get"]: action = "take"
	elif action in ["attack", "slam", "hit"]: action = "attack"
	
	var idx: int = 1
	if input[1] in ["at", "in", "through", "towards", "to", "up"]: # checking for prepositions
		idx += 1
		if input.size() == idx: return
		if input[2] in ["at", "in", "through", "towards", "to", "up"]: # checking for prepositions x2
			idx += 1
			if input.size() == idx: return
	if input.slice(idx)[0] in ["a", "an", "the"]: # checking for articles
		idx += 1
		if input.size() == idx: return
	
	var target: String
	var item: String
	# determining target/item order:
	if "on" in input or "with" in input: # with item
		if input[idx + 1] == "with": # target, then item
			target = input[idx]
			# checking for articles:
			if input[idx + 2] in ["a", "an", "the"]: item = input[idx + 3]
			else: item = input[idx + 2]
		elif input[idx + 1] == "on": # item, then target
			item = input[idx]
			# checking for articles:
			if input[idx + 2] in ["a", "an", "the"]: target = input[idx + 3]
			else: target = input[idx + 2]
		# checking if player has item:
		if item != "key" and item not in global.data.inventory:
			if item.substr(0, 1) in ["a", "e", "i", "o", "u"]:
				global.get_ui().print_to_log("You don't have an %s." % item, Output.ERROR)
			else:
				global.get_ui().print_to_log("You don't have a %s." % item, Output.ERROR)
			item = ""
	else: # either no item or target is item
		target = input[idx]
		# checking for 2-word target:
		if input.size() == idx + 2 and global.room.get_target(" ".join([input[idx], input[idx + 1]])) != null:
			print("2-word target detected: ", " ".join([input[idx], input[idx + 1]]))
		# global action/target pairs:
		if action == "move" and target == "back":
			global.switch_room(global.data.last_room)
		elif action == "light":
			if target == "candle" and "candle_unlit" in global.data.inventory:
				global.data.replace_item("candle_unlit", "candle")
			elif target == "match" and "matchbox" in global.data.inventory:
				global.get_ui().print_to_log(["Don't want to be wasting these.", "You shouldn't.", "You'll burn your hand."].pick_random())
	
	# passing to room:
	print('COMMAND: action: "%s", target: "%s", item: "%s"' % [action, target, item])
	global.room.on_command_given(action, target, item)
