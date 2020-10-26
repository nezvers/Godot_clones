extends KinematicBody2D


export var speed: = 4.0 * 60
var direction:Vector2
var remainder:float
onready var width = get_viewport_rect().size.x
onready var tween: = $Tween
onready var radius:float = $CollisionShape2D.shape.radius

func _draw()->void:
	draw_circle(Vector2.ZERO, radius, Color.white)

func _ready()->void:
	update()
	choose_direction()
	set_physics_process(false)
	tween.connect("tween_all_completed", self, "tween_finished")
	tween.interpolate_property(self, "radius", radius * 50, radius, 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	Score.visible = true

func choose_direction()->void:
	direction = Vector2(rand_range(0.5, 1.0), rand_range(-0.5, 0.5)).normalized()
	direction.x *= (randi() % 2) *2 -1

func _physics_process(delta:float)->void:
	var collision = move_and_collide((direction * speed * delta) + direction * remainder, false)
	if collision:
		var normal = collision.normal
		direction = direction.bounce(normal)
		remainder = collision.remainder.length()
		
		#only KinematicBody2D in game are ball and paddles
		if collision.collider is KinematicBody2D:
			#give rotation depending how far from paddle height center
			var collider:KinematicBody2D = collision.collider
			var distance = collider.global_position.y - global_position.y
			#reverse turn if right paddle
			var turn_dir = sign(collider.global_position.x - global_position.x)
			var turn_ratio = 0.01
			var angle = PI*0.25 * (distance * turn_ratio * turn_dir)
			direction = direction.rotated(angle)
	else:
		remainder = 0.0
	
	check_goal()

func check_goal()->void:
	if global_position.x < 0.0:
		#Left win
		Score.score_left += 1
		Score.draw_score()
		get_tree().reload_current_scene()
	elif global_position.x > width:
		#right win
		Score.score_right += 1
		Score.draw_score()
		get_tree().reload_current_scene()

func _process(_delta:float)->void:
	update()

func tween_finished()->void:
	update()
	set_process(false)
	set_physics_process(true)
	Score.visible = false







