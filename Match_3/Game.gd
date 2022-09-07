extends Control

export (Array, Texture) var iconTextures: Array
export var buttonPrefab:PackedScene

const WIDTH: = 6
const HEIGHT: = 6
enum {MILK, APPLE, ORANGE, TOAST, BROKOLI, COCONUT, STAR, ICON_COUNT}

var iconSize:float
var grid: = []

class Item:
	var type:int
	var button:ToolButton
	func _init(_type:int, _button:ToolButton):
		type = _type
		button = _button

func _ready()->void:
	var size: = get_viewport_rect().size
	iconSize = min(size.x, size.y) / HEIGHT
	StartGrid()

func StartGrid()->void:
	grid.clear() # for level restart
	grid.resize(WIDTH * HEIGHT) # allocate space
	
	for y in HEIGHT:
		for x in WIDTH:
			SpawnIcon(x, y, randi() % ICON_COUNT)

func SpawnIcon(x:int, y:int, type:int)->void:
	var icon:ToolButton = buttonPrefab.instance()
	icon.icon = iconTextures[type]
	icon.expand_icon = true
	icon.rect_size = Vector2.ONE * iconSize
	add_child(icon)
	icon.rect_position = Vector2(x * iconSize, y * iconSize)
	
	var item: = Item.new(type, icon)
	grid[WIDTH * y + x] = item
	
	icon.connect("pressed", self, "IconPressed", [item])

func IconPressed(item:Item)->void:
	print(item)
