extends KinematicBody2D

export var action_up:String = "p1_up"
export var action_down:String = "p1_down"

export var speed:float = 8.0 * 60.0
var velocity:Vector2

func _physics_process(_delta:float):
	var dir:float
	dir = Input.get_action_strength(action_down) - Input.get_action_strength(action_up)
	velocity.y = dir * speed
	move_and_slide(velocity, Vector2.UP, true, 1, 1, false)
