extends Label
class_name Output


enum {DEFAULT, COMMAND, ERROR, TUTORIAL}

var type: int = DEFAULT
var last_line_count: int = 1


func _ready():
	autowrap_mode = TextServer.AUTOWRAP_WORD
	match type:
		DEFAULT:
			theme_type_variation = &"OutputText"
			visible_characters = 0
			var timer = Timer.new()
			timer.name = "Timer"
			timer.one_shot = true
			timer.connect("timeout", reveal_text)
			add_child(timer)
			timer.start(0.05)
		COMMAND:
			theme_type_variation = &"OutputCommand"
			text = "> " + text
		ERROR:
			theme_type_variation = &"OutputError"
			text = "// " + text
		TUTORIAL:
			add_theme_color_override("font_color", Color("#879b42"))


func reveal_text():
	if text[visible_characters] in [".", ",", "!", "?", "-", ":"]:
		$Timer.start(0.2)
	else:
		$Timer.start(0.02)
	
	visible_characters += 1
	if visible_characters == get_total_character_count():
		$Timer.queue_free()
	
	if get_visible_line_count() != last_line_count:
		last_line_count = get_visible_line_count()
		global.get_ui().scroll_down()
