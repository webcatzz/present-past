extends PanelContainer


@onready var background = $VBox/Display/Background
@onready var inventory = $VBox/Controls/Inventory/Margin/HBox
@onready var log_scroller = $VBox/Controls/Frame/TextInput/Log/Scroller
@onready var log_container = $VBox/Controls/Frame/TextInput/Log/Scroller/VBox
@onready var input_edit = $VBox/Controls/Frame/TextInput/Input/HBox/Edit
@onready var texture_display = $VBox/Controls/Frame/TextureDisplay/Texture
@onready var animator = $Animator


func _ready():
	input_edit.grab_focus()
	global.room_changed.connect(on_room_changed)
	global.data.item_added.connect(on_item_added)
	global.data.item_removed.connect(on_item_removed)
	global.data.item_replaced.connect(on_item_replaced)
	global.switch_room(global.data.room)
	
	for i in global.data.inventory:
		on_item_added(i)


func on_input_submitted(input: String):
	input_edit.clear()
	print_to_log(input, Output.COMMAND) # printing input
	processor.process(input) # passing input to processor


func print_to_log(text: String, type: int = 0):
	if text.is_empty(): return
	
	var message = Output.new()
	message.text = text
	message.type = type
	log_container.add_child(message)
	
	await get_tree().process_frame
	scroll_down()


func scroll_down():
	create_tween().tween_property(log_scroller, "scroll_vertical", log_scroller.get_v_scroll_bar().max_value, 0.2)



func on_room_changed():
	animator.play("fade_background")
	await animator.animation_finished
	
	background.texture = global.room.background # setting background
	for target in background.get_children(): # freeing old targets
		target.queue_free()
	for target in global.room.targets: # adding new targets
		if target is VisibleTarget:
			var sprite = Sprite2D.new()
			sprite.centered = false
			sprite.texture = target.sprite
			sprite.position = target.position
			if target.frames.size() > 0: sprite.hframes = target.frames.size()
			target.frame_changed.connect(sprite.set_frame)
			sprite.visible = target.visible
			target.visibility_changed.connect(sprite.set_visible)
			
			if target is Door and "key_" + target.key_id + "_used" in global.data.flags:
				if target.frames.size() > 0: sprite.frame = sprite.hframes - 1
				else: target.visible = false
			
			background.add_child(sprite)
	if global.room.music != null: # playing music
		global.play(global.room.music, global.music)
	if !global.room.intro.is_empty() and "intro_" + global.data.room + "_seen" not in global.data.flags: # printing intro
		global.data.flags.append("intro_" + global.data.room  + "_seen")
		print_to_log(global.room.intro)
	
	animator.play_backwards("fade_background")


func on_item_added(item: String):
	var new_slot = load("res://data/ui/slot.tscn").instantiate()
	inventory.add_child(new_slot)
	new_slot.set_item(item)


func on_item_removed(idx: int):
	inventory.get_child(idx).queue_free()


func on_item_replaced(idx: int, item: String):
	inventory.get_child(idx).set_item(item)


func display_texture(path: String):
	if ResourceLoader.exists(path):
		texture_display.texture = load(path)
	else:
		print_to_log("error: texture not found!", Output.ERROR)
		return
	
	animator.play("display_texture")
	await animator.animation_finished
	
	# ...
	
	animator.play("undisplay_texture")


func toggle_input(value: bool):
	input_edit.editable = value
	if value:
		$VBox/Controls/Frame/TextInput/Input.modulate.v = 1
		input_edit.grab_focus()
	else:
		$VBox/Controls/Frame/TextInput/Input.modulate.v = 0.5
