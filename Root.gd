extends Control

func _ready():
	#OS.min_window_size = Vector2(588, 588)
	#Data.load_data()
	$CRT.visible = true

func _input(_InputEvent):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
