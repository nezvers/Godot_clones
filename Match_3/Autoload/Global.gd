extends Node2D # Node2D to get access to viewport

const WIDTH: = 6
const HEIGHT: = 6

var iconSize:float

func _ready()->void:
	var size: = get_viewport_rect().size
	iconSize = min(size.x, size.y) / Global.HEIGHT


