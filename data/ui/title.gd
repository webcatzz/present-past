extends TabContainer


func _ready():
	if global.data.name.is_empty():
		$TitleScreen/Buttons/Start.text = "load"


func on_start_pressed():
	if global.data.name.is_empty():
		$Animator.play("fade_out")
		await $Animator.animation_finished
		current_tab = 1
		$Name/VBox/LineEdit.grab_focus()
		$Animator.play_backwards("fade_out")
	else:
		$Animator.play("fade_out")
		await $Animator.animation_finished
		get_tree().change_scene_to_file("res://data/ui/main.tscn")


func on_settings_pressed():
	global.get_node("Settings").toggle()


func on_quit_pressed():
	get_tree().quit()


func on_name_entered():
	if !$Name/VBox/LineEdit.text.is_empty():
		$Name/VBox/LineEdit.editable = false
		global.data.name = $Name/VBox/LineEdit.text
		$Animator.play("fade_out")
		await $Animator.animation_finished
		get_tree().change_scene_to_file("res://data/ui/main.tscn")
