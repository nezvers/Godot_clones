extends KinematicBody2D

export var jumpImpulse = 6.5 *60
export var gravityImpulse: = 8.0 * 60
export var spd = 3.0 * 60
var dir: = 0.0
var velocity: = Vector2.ZERO

func _physics_process(delta:float)->void:
	dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y += gravityImpulse*delta
	if is_on_floor():
		velocity.y = -jumpImpulse
	
	velocity.x = dir * spd
	move_and_slide(velocity, Vector2.UP)
