extends Control

export (Array, Texture) var iconTextures: Array
export var buttonPrefab:PackedScene


enum {MILK, APPLE, ORANGE, TOAST, BROKOLI, COCONUT, STAR, ICON_COUNT}

var grid: = [] #shared with items


func _ready()->void:
	StartGrid()

func StartGrid()->void:
	grid.clear() # for level restart
	grid.resize(Global.WIDTH * Global.HEIGHT) # allocate space
	
	for y in Global.HEIGHT:
		for x in Global.WIDTH:
			var index: int = Global.WIDTH * y + x
			SpawnIcon(x, Global.HEIGHT - y -1, randi() % ICON_COUNT, index) # start from bottom

func SpawnIcon(x:int, y:int, type:int, index:int)->void:
	var icon:ToolButton = buttonPrefab.instance()
	icon.icon = iconTextures[type]
	icon.expand_icon = true
	icon.rect_size = Vector2.ONE * Global.iconSize
	icon.rect_position = Vector2(x * Global.iconSize, y * Global.iconSize)
	
	icon.spawnIndex = index # icon will tween
	icon.grid = grid # share grid
	icon.type = type # give it type
	grid[Global.WIDTH * y + x] = icon # place in the grid
	add_child(icon) # add to the scene tree

