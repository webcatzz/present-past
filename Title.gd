extends Control

func dropmenu():
	$CenterContainer/VBoxContainer/Button.visible = true


func _on_Button_pressed():
	self.queue_free()
