extends Node

var worldGrid = []
var worldWidth = 32
var worldHeight = 16
var worldRules = []

var worldLerpTime = 1
var worldAnimationFrame = 0

var worldColorScheme = 0

var animtimer = 0

onready var tilePrefab = preload("res://src/tile.tscn")

var tileDatabase = {
	"baba": {"type": 0, "x": 1, "y": 0, "walkCycle": 4, "color": 21},
	"baba_obj": {"type": 1, "x": 6, "y": 0, "walkCycle": 0, "color": 11},
	"is_op": {"type": 2, "x": 18, "y": 0, "walkCycle": 0, "color": 21},
	"you_act": {"type": 3, "x": 20, "y": 0, "walkCycle": 0, "color": 11},
}

func _ready():
	for x in range(worldWidth):
		worldGrid.append([])
		for y in range(worldHeight):
			worldGrid[x].append(null)
	
	spawnTile(0, 0, 0, "baba")
	spawnTile(2, -1, 0, "baba_obj")
	spawnTile(2, 0, 0, "is_op")
	spawnTile(2, 1, 0, "you_act")
	
	checkTheRules()

func _process(delta):
	animtimer += delta
	if (animtimer > 0.1):
		animtimer -= 0.1
		worldAnimationFrame += 1
		for x in range(worldWidth):
			for y in range(worldHeight):
				if (worldGrid[x][y] != null):
					worldGrid[x][y].updateSpriteAnim()
		if (worldAnimationFrame > 2):
			worldAnimationFrame = 0
	if (worldLerpTime < 1):
		worldLerpTime += delta * 2
		if (worldLerpTime > 1):
			worldLerpTime = 1
			checkTheRules()
	else:
		pass
		
func spawnTile(x, y, direction, name) -> void:
	var spawnedTile = tilePrefab.instance()
	spawnedTile.main = self
	spawnedTile.updatePos(x, y)
	spawnedTile.direction = direction
	worldGrid[x][y] = spawnedTile
	changeTileType(x, y, name)
	
func changeTileType(x, y, name) -> void:
	worldGrid[x][y].tileName = name
	worldGrid[x][y].tileType = tileDatabase[name]["type"]
	worldGrid[x][y].updateSprite(tileDatabase[name]["x"], tileDatabase[name]["y"], tileDatabase[name]["walkCycle"], tileDatabase[name]["color"])

func destroyTile(x, y) -> void:
	pass

func updateWorld() -> void:
	for x in range(worldWidth):
		for y in range(worldHeight):
			if (worldGrid[x][y] != null):
				pass
	worldLerpTime = 0
	checkTheRules()
	
func checkTheRules() -> void:
	for x in range(worldWidth):
		for y in range(worldHeight):
			pass