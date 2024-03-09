extends Node


signal room_changed

var data: Resource = load("res://data/player/saved.tres")
var room: Resource

@onready var music = $Music
@onready var sfx = $SFX
var sfx_list: Dictionary = {
	"noise": load("res://assets/sfx/noise.mp3"),
	"noise_high": load("res://assets/sfx/noise_high.mp3"),
	"noise_low": load("res://assets/sfx/noise_low.mp3"),
	"click": load("res://assets/sfx/click.mp3"),
	"latch": load("res://assets/sfx/latch.mp3"),
	"phone": load("res://assets/sfx/phone.mp3"),
	"flame": load("res://assets/sfx/flame.mp3"),
}


# data stuff

func switch_room(room_name: String):
	room = load("res://data/rooms/" + room_name + ".tres") # loading room data
	data.last_room = data.room # saving last room for "back" commands
	data.room = room_name # saving new room to data
	emit_signal("room_changed")


func set_item(item_name: String, exists: bool):
	if exists: data.inventory.append(item_name)
	else: data.inventory.erase(item_name)
	emit_signal("inventory_changed", item_name, exists)


func get_item(item_name: String):
	return load("res://assets/items/" + item_name + ".tres")


func save_data():
	ResourceSaver.save(data, "res://data/player/saved.tres")

# audio

func play(resource: AudioStreamMP3, audio_player: AudioStreamPlayer):
	if audio_player == global.music and audio_player.stream == resource: return
	
	audio_player.stream = resource
	audio_player.play()
	print("Now playing: ", resource.resource_path)


func play_sfx(sfx_name: String):
	play(sfx_list[sfx_name], global.sfx)


# misc.

func get_ui():
	return get_node_or_null("/root/Main")


func wait(time: float):
	$Timer.start(time)
	await $Timer.timeout


func _unhandled_key_input(event: InputEvent):
	if event.is_action_released("escape"):
		$Settings.toggle()
