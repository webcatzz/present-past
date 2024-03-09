extends Target
class_name VisibleTarget


signal visibility_changed
signal frame_changed

@export_group("Appearance")
@export var sprite: Texture
@export var position: Vector2
@export var visible: bool = true:
	set(value):
		visible = value
		emit_signal("visibility_changed", value)

@export_group("Animation")
@export var frames: PackedFloat32Array
@export var frame_sfx: PackedStringArray


func play_animation():
	global.get_ui().toggle_input(false)
	frame_sfx.resize(frames.size())
	for i in frames.size():
		emit_signal("frame_changed", i)
		if !frame_sfx[i].is_empty():
			global.play_sfx(frame_sfx[i])
		if frames[i] != 0:
			await global.wait(frames[i])
	global.get_ui().toggle_input(true)
