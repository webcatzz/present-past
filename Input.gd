extends LineEdit

func _ready():
	grab_focus()

func _on_InputField_text_changed(_new_text):
	$Typing.play()

func _on_Input_text_entered(new_text):
	Main.handle(new_text)
	clear()
