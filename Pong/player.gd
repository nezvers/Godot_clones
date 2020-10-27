extends KinematicBody2D

export var action_up:String = "p1_up"
export var action_down:String = "p1_down"

export var speed:float = 3.0 * 60.0

func _physics_process(_delta:float):
	var dir:float
	dir = Input.get_action_strength(action_down) - Input.get_action_strength(action_up)
	move_and_collide(Vector2.DOWN * dir * speed * _delta, false)
