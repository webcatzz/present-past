extends TextureRect

var index = 0


func _ready():
	Main.play("music", "ENCOUNTER")


func _on_Timer_timeout():
	index += 1
	match index:
		1:
			Main.output("HELLO")
			$Timer.start(1)
		2:
			Main.output("Do")
			$Timer.start(0.25)
		3:
			Main.output("U.")
			$Timer.start(0.25)
		4:
			Main.output("HAVE GAMES")
			$Timer.start(2)
		5:
			Main.output("oN YOIUR PHON3.")
			$Timer.start(3)
		6:
			Main.output("...")
			Main.Music.stop()
			$Timer.start(0.1)
		7:
			Main.output("FUCK YOU")
			Main.play("sfx", "static")
			$Timer.start(0.1)
		8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20:
			Main.output("FUCK YOU")
			$Timer.start(0.1)
		21:
			get_tree().quit()
