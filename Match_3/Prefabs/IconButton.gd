extends ToolButton

export var fallTime: = 0.5
export var delayTime: = 0.032
export var pressTime: = 0.5

var spawnIndex: = 0 # for nice tweening

var grid: = [] # holds shared grid data
var type: = -1
var isActive: = false
var tweener: SceneTreeTween

func _ready()->void:
	rect_pivot_offset = rect_size * 0.5
	
	tweener = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var to: = rect_position
	rect_position = to - Vector2(0, Global.HEIGHT * Global.iconSize)
# warning-ignore:return_value_discarded
	tweener.tween_property(self, "rect_position", to, fallTime).set_delay(delayTime * spawnIndex)
# warning-ignore:return_value_discarded
	tweener.tween_callback(self, "SetActive", [true])

func SetActive(value:bool)->void:
	isActive = value

func _pressed()->void:
	if !isActive:
		return
	# allow repeated click tweens
	if tweener.is_valid() && tweener.is_running():
		tweener.kill()
	
	tweener = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	rect_scale = Vector2.ONE * 0.3
# warning-ignore:return_value_discarded
	tweener.tween_property(self, "rect_scale", Vector2.ONE, pressTime)
