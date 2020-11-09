extends Node2D


onready var tween: = $Tween
onready var screenSize: = get_viewport_rect().size
onready var width = get_viewport_rect().size.x
onready var paddleL: = $"../PaddleL"
onready var paddleR: = $"../PaddleR"

export var speed: = 4.0 * 60
var direction:Vector2
var remainder:float
var radius:float = 8
var lastPos: = position

func _draw()->void:
	draw_circle(Vector2.ZERO, radius, Color.white)

func _ready()->void:
	update()
	choose_direction()
	tween.connect("tween_all_completed", self, "tween_finished")
	tween.interpolate_property(self, "radius", radius * 50, radius, 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	Score.visible = true

func choose_direction()->void:
	direction = Vector2(rand_range(0.5, 1.0), rand_range(-0.5, 0.5)).normalized()
	direction.x *= (randi() % 2) *2 -1

func _process(delta:float)->void:
	if(!tween.is_active()):
		move(delta)
		wall_check()
		paddle_check()
		check_goal()
	else:
		update()

func move(delta:float)->void:
	lastPos = position
	position += direction * speed * delta

func wall_check()->void:
	if position.y < 16.0 + radius:
		#ceiling
		position.y = 16.0 + radius
		direction = direction.bounce(Vector2.DOWN)
	elif position.y > screenSize.y - 16 - radius:
		#floor
		position.y = 360.0 - 16 - radius
		direction = direction.bounce(Vector2.UP)

func paddle_check()->void:
	if position.x < 16.0 + radius:
		if lastPos >= paddleL.position.x + radius:
			pass
	elif position.x > screenSize.x - 16 - radius:
		pass

func collidePaddle(collider: Node2D)->void:
	#give rotation depending how far from paddle height center
	var distance = collider.global_position.y - global_position.y
	#reverse turn if right paddle
	var turn_dir = sign(collider.global_position.x - global_position.x)
	var turn_ratio = 0.01
	var angle = PI*0.25 * (distance * turn_ratio * turn_dir)
	direction = direction.rotated(angle)

func check_goal()->void:
	if global_position.x < 0.0:
		#Left win
		Score.score_right += 1
		Score.draw_score()
		get_tree().reload_current_scene()
	elif global_position.x > screenSize.x:
		#right win
		Score.score_left += 1
		Score.draw_score()
		get_tree().reload_current_scene()

func tween_finished()->void:
	update()
	Score.visible = false







