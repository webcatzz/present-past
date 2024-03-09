extends ScrollContainer

var stored_max_scroll := 0
var scrollbar = get_v_scrollbar()

func _ready():
	scrollbar.connect("changed", self, "scroll_to_bottom")
	stored_max_scroll = scrollbar.max_value 

func scroll_to_bottom(): 
	if stored_max_scroll != scrollbar.max_value:
		stored_max_scroll = scrollbar.max_value
		$Tween.interpolate_property(self, "scroll_vertical",
			scroll_vertical, scrollbar.max_value, 1,
			Tween.TRANS_CIRC, Tween.EASE_OUT)
		$Tween.start()
