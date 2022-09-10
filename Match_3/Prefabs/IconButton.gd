extends ToolButton

export var fallTime: = 0.5
export var delayTime: = 0.032

var spawnIndex: = 0 # for nice tweening

func _ready()->void:
	var tweener: = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var to: = rect_position
	rect_position = to - Vector2(0, Global.HEIGHT * Global.iconSize)
# warning-ignore:return_value_discarded
	tweener.tween_property(self, "rect_position", to, fallTime).set_delay(delayTime * spawnIndex)
