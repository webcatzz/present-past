extends TextureRect


func runCommand(object, _action, _item):
	match object:
		"newspaper":
			return "Some trashy paper I picked up along the way. Has an article about some disappearance last week."
		"letter", "envelope":
			return "A letter, one I wasn't too happy to recieve. It's from my parents' insurance company, telling me I inherited their house - my childhood home."
		"ticket":
			return "My train ticket, freshly punched. A one-way trip to the past."
		"examine":
			return "A train, trundling slowly toward the future. I'm hopping off at the next stop."
