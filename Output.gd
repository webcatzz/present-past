extends RichTextLabel

func _ready():
	$Timer.start(0.05)

func _on_Timer_timeout():
	if text[visible_characters] in [".", ",", "!", "?", "-", ":"]:
		$Timer.start(0.2)
	else:
		$Timer.start(0.02)
	
	visible_characters += 1
	if visible_characters == get_total_character_count():
		$Timer.queue_free()
