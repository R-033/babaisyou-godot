extends Node

var worldGrid = []
var worldWidth = 17
var worldHeight = 16
var worldRules = []

var worldLerpTime = 1
var worldAnimationFrame = 0

var worldColorPalette = 0

var animtimer = 0

onready var tilePrefab = preload("res://src/tile.tscn")

var tileDatabase = {
	"baba": {"type": 0, "x": 1, "y": 0, "walkCycle": 4, "color": 21},
	"baba_obj": {"type": 1, "x": 6, "y": 27, "walkCycle": 0, "color": 11},
	"is_op": {"type": 2, "x": 18, "y": 30, "walkCycle": 0, "color": 21},
	"you_act": {"type": 3, "x": 20, "y": 42, "walkCycle": 0, "color": 11},
}

func _ready():
	OS.set_window_size(Vector2(worldWidth * 24, worldHeight * 24))
	
	for x in range(worldWidth):
		worldGrid.append([])
		for y in range(worldHeight):
			worldGrid[x].append(null)
	
	spawnTile(7, 7, 0, "baba")
	spawnTile(9, 6, 0, "baba_obj")
	spawnTile(9, 7, 0, "is_op")
	spawnTile(9, 8, 0, "you_act")
	
	checkTheRules()

func _process(delta):
	animtimer += delta
	if (animtimer > 0.1):
		animtimer -= 0.25
		worldAnimationFrame += 1
		if (worldAnimationFrame > 2):
			worldAnimationFrame = 0
		for x in range(worldWidth):
			for y in range(worldHeight):
				if (worldGrid[x][y] != null):
					worldGrid[x][y].updateSpriteAnim()
	if (worldLerpTime < 1):
		worldLerpTime += delta * 2
		if (worldLerpTime > 1):
			worldLerpTime = 1
			checkTheRules()
	else:
		pass
		
func spawnTile(x, y, direction, name) -> void:
	var spawnedTile = tilePrefab.instance()
	add_child(spawnedTile)
	spawnedTile.main = self
	spawnedTile.updatePos(x, y)
	spawnedTile.direction = direction
	worldGrid[x][y] = spawnedTile
	changeTileType(x, y, name)
	
func changeTileType(x, y, name) -> void:
	worldGrid[x][y].tileName = name
	worldGrid[x][y].tileType = tileDatabase[name]["type"]
	var color_x = tileDatabase[name]["color"]
	var color_y = 0
	while (color_x > 6):
		color_x -= 7
		color_y += 1
	var color_palette_x = worldColorPalette
	var color_palette_y = 0
	while (color_palette_x > 3):
		color_palette_x -= 4
		color_palette_y += 1
	var textureData = worldGrid[x][y].get_texture().get_data();
	textureData.lock()
	var color = textureData.get_pixel(
		20 * 24 + 12 + color_palette_x * (3 * 24) + color_x * 8,
		24 + color_palette_y * (3 * 24 - 12) + color_y * 8
	)
	textureData.unlock()
	worldGrid[x][y].updateSprite(tileDatabase[name]["x"], tileDatabase[name]["y"], tileDatabase[name]["walkCycle"], color)

func destroyTile(x, y) -> void:
	pass

func updateWorld() -> void:
	worldLerpTime = 0
	for x in range(worldWidth):
		for y in range(worldHeight):
			if (worldGrid[x][y] != null):
				pass
	checkTheRules()
	
func checkTheRules() -> void:
	for x in range(worldWidth):
		for y in range(worldHeight):
			pass