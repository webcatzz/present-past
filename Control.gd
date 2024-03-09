extends Control

var clicked = false

func _input(event):
	if event is InputEventMouseButton and !clicked:
		clicked = true
		self.owner.dropmenu()
