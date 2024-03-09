extends Resource


@export var background: Texture2D
@export var targets: Array[Target]
@export var music: AudioStreamMP3
@export_multiline var intro: String


func on_command_given(action: String, target_name: String, item: String):
	var target = get_target(target_name)
	if target != null: target.affect(action, item)


func get_target(target: String):
	for t in targets:
		for n in t.names:
			if n == target:
				return t
	return null
