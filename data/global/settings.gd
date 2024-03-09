extends CanvasLayer


func _ready():
	$Container/Separator/Volume/MasterSlider.value = global.data.master_volume
	$Container/Separator/Volume/MusicSlider.value = global.data.music_volume
	$Container/Separator/Volume/SfxSlider.value = global.data.sfx_volume


func toggle():
	if !visible:
		$Gear.position.x = -16
		$Gear.modulate.a = 0
		$Container.position.x = -32
		$Container.size.x = 0
		$Container.modulate.a = 0
		$Container/Separator.modulate.a = 0
		visible = true
		var tween = create_tween().set_ease(Tween.EASE_OUT)
		tween.tween_property($Container, "size:x", 70, 0.3)
		tween.parallel().tween_property($Container, "position:x", 0, 0.3)
		tween.parallel().tween_property($Container, "modulate:a", 1, 0.3)
		tween.parallel().tween_property($Gear, "position:x", 0, 0.3)
		tween.parallel().tween_property($Gear, "modulate:a", 1, 0.3)
		tween.tween_callback($Container/Separator.set_visible.bind(true))
		tween.tween_property($Container/Separator, "modulate:a", 1, 0.2)
	else:
		var tween = create_tween().set_ease(Tween.EASE_IN)
		tween.tween_property($Container/Separator, "modulate:a", 0, 0.2)
		tween.tween_callback($Container/Separator.set_visible.bind(false))
		tween.tween_property($Container, "size:x", 0, 0.3)
		tween.parallel().tween_property($Container, "position:x", -32, 0.3)
		tween.parallel().tween_property($Container, "modulate:a", 0, 0.3)
		tween.parallel().tween_property($Gear, "position:x", -16, 0.3)
		tween.parallel().tween_property($Gear, "modulate:a", 0, 0.3)
		await tween.finished
		visible = false
		$Container/Separator.visible = false
