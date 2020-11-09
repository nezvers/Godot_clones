extends Node2D
class_name Paddle

var height:float = 40.0
var width:float = 4.0
onready var screenHeight = get_viewport_rect().size.y

func _draw()->void:
	var rect = Rect2(Vector2(-width, -height), Vector2(width, height*2))
	draw_rect(rect, Color.white, true, 0.0, false)

func move(delta:float)->void:
	pass
	

func _process(delta:float):
	move(delta)
	position.y = clamp(position.y, 16+height, screenHeight -16 -height)
