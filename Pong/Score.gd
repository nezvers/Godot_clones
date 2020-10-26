extends PanelContainer

onready var label: = $Label

var score_left: = 0
var score_right = 0

func draw_score()->void:
	label.text = str(score_left) + ' : ' + str(score_right)
