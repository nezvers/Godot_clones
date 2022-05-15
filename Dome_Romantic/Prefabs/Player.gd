extends KinematicBody2D

export var moveSpeed: = 60.0
export var acceleration: = 10.0
export var strength: = 5
export var springScene:PackedScene
export var areaPath:NodePath

onready var area:Area2D = get_node(areaPath)

var velocity: = Vector2.ZERO
var dir: = Vector2.ZERO
var bumpStrength: = 120.0 # works together with acceleration
var itemList: = []
var springList: = []

func _draw():
	for item in itemList:
		draw_line(Vector2.ZERO, item.global_position - global_position, Color.white)

func _physics_process(delta):
	dir = Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	dir = dir.normalized()
	
	var caryMultiply: = max(1 - itemList.size()/float(strength), 0.0)
	var targetVelocity:Vector2 = moveSpeed * dir * caryMultiply
	velocity = velocity.linear_interpolate(targetVelocity, delta * acceleration)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for i in get_slide_count():
		var col: = get_slide_collision(i) #KinematicCollision2D
		if col:
			velocity += col.normal * bumpStrength
	# draw connections
	update()

func _unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("interact"):
		var items: = area.get_overlapping_bodies()
		for item in items:
			if !itemList.has(item):
				ConnectItem(item)
				return
		RemoveItem()

func ConnectItem(item:PhysicsBody2D)->void:
	if !(itemList.size() < strength -1):
		return
	var spring:DampedSpringJoint2D = springScene.instance()
	add_child(spring)
	spring.node_a = spring.get_path_to(self)
	spring.node_b = spring.get_path_to(item)
	itemList.append(item)
	springList.append(spring)

func RemoveItem()->void:
	if itemList.empty():
		return
	var spring:DampedSpringJoint2D = springList.pop_back()
	spring.queue_free()
	var item:PhysicsBody2D = itemList.pop_back()
