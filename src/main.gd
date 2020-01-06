extends Node

var worldGrid = []
var worldRules = {}
var worldWidth = 17
var worldHeight = 16

var worldLerpTime = 1
var worldAnimationFrame = 0

var worldColorPalette = 0

var animtimer = 0

var unappliedMovement = null

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
			worldGrid[x].append([])
	
	spawnTile(7, 7, 0, "baba")
	spawnTile(7, 5, 0, "baba")
	spawnTile(7, 3, 0, "baba")
	spawnTile(10, 6, 0, "baba")
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
				for i in range(worldGrid[x][y].size()):
					worldGrid[x][y][i].updateSpriteAnim()
	if (worldLerpTime < 1):
		worldLerpTime += delta * 10
		if (worldLerpTime > 1):
			worldLerpTime = 1
			checkTheRules()

func _input(ev):
	if (worldLerpTime != 1):
		return
	if Input.is_key_pressed(KEY_SPACE):
		unappliedMovement = Vector2(0, 0)
		worldLerpTime = 0
		updateWorld()
	elif Input.is_key_pressed(KEY_RIGHT):
		unappliedMovement = Vector2(1, 0)
		worldLerpTime = 0
		updateWorld()
	elif Input.is_key_pressed(KEY_UP):
		unappliedMovement = Vector2(0, -1)
		worldLerpTime = 0
		updateWorld()
	elif Input.is_key_pressed(KEY_LEFT):
		unappliedMovement = Vector2(-1, 0)
		worldLerpTime = 0
		updateWorld()
	elif Input.is_key_pressed(KEY_DOWN):
		unappliedMovement = Vector2(0, 1)
		worldLerpTime = 0
		updateWorld()

func spawnTile(x, y, direction, name) -> void:
	var spawnedTile = tilePrefab.instance()
	add_child(spawnedTile)
	spawnedTile.main = self
	spawnedTile.updatePos(x, y)
	spawnedTile.direction = direction
	changeTileType(spawnedTile, name)
	worldGrid[x][y].append(spawnedTile)
	
func changeTileType(tile, name) -> void:
	tile.tileName = name
	tile.tileType = tileDatabase[name]["type"]
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
	var textureData = tile.get_texture().get_data();
	textureData.lock()
	var color = textureData.get_pixel(
		20 * 24 + 12 + color_palette_x * (3 * 24) + color_x * 8,
		24 + color_palette_y * (3 * 24 - 12) + color_y * 8
	)
	textureData.unlock()
	tile.updateSprite(tileDatabase[name]["x"], tileDatabase[name]["y"], tileDatabase[name]["walkCycle"], color)

func destroyTile(tile) -> void:
	var wasPartOfCondition = tile.tileType != 0
	worldGrid[tile.pos.x][tile.pos.y].erase(tile)
	remove_child(tile)
	if (wasPartOfCondition):
		checkTheRules()

func updateWorld(allowMovement = true) -> void:
	var alreadyFinished = []
	for x in range(worldWidth):
		for y in range(worldHeight):
			for i in range(worldGrid[x][y].size()):
				if (i > worldGrid[x][y].size() - 1):
					i = 0
				var tile = worldGrid[x][y][i]
				if (alreadyFinished.has(tile)):
					continue
				if (worldLerpTime == 0 && unappliedMovement != null && ifRuleActive(worldGrid[x][y][i].tileName, "is", "you")):
					push_tile(tile, unappliedMovement.x, unappliedMovement.y, alreadyFinished)
				# todo apply rules and stuff
	if (worldLerpTime == 0):
		unappliedMovement = null

func push_tile(tile, delta_x, delta_y, alreadyFinished) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	for j in range(worldGrid[newX][newY].size()):
		var pushedTile = worldGrid[newX][newY][j]
		if (pushedTile.tileType != 0 || ifRuleActive(tile.tileName, "is", "push")):
			if (!can_be_pushed(pushedTile, delta_x, delta_y)):
				return false
	for j in range(worldGrid[newX][newY].size()):
		var pushedTile = worldGrid[newX][newY][j]
		if (pushedTile.tileType != 0 || ifRuleActive(tile.tileName, "is", "push")):
			push_tile(pushedTile, delta_x, delta_y, null)
	worldGrid[tile.pos.x][tile.pos.y].erase(tile)
	tile.updatePos(newX, newY)
	worldGrid[newX][newY].append(tile)
	if (alreadyFinished != null):
		alreadyFinished.append(tile)
	return true

func can_be_pushed(tile, delta_x, delta_y) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	for j in range(worldGrid[newX][newY].size()):
		var pushedTile = worldGrid[newX][newY][j]
		if (pushedTile.tileType != 0 || ifRuleActive(tile.tileName, "is", "push")):
			if (!can_be_pushed(pushedTile, delta_x, delta_y)):
				return false
	return true

func checkTheRules() -> void:
	worldRules.clear()
	for x in range(worldWidth):
		for y in range(worldHeight):
			for i in range(worldGrid[x][y].size()):
				if (worldGrid[x][y][i].tileType == 1):
					if (x < worldWidth - 2):
						for j in range(worldGrid[x + 1][y].size()):
							if (worldGrid[x + 1][y][j].tileType == 2):
								for g in range(worldGrid[x + 2][y].size()):
									if (worldGrid[x + 2][y][g].tileType == 3):
										applyRule(worldGrid[x][y][i], worldGrid[x + 1][y][j], worldGrid[x + 2][y][g])
					if (y < worldHeight - 2):
						for j in range(worldGrid[x][y + 1].size()):
							if (worldGrid[x][y + 1][j].tileType == 2):
								for g in range(worldGrid[x][y + 2].size()):
									if (worldGrid[x][y + 2][g].tileType == 3):
										applyRule(worldGrid[x][y][i], worldGrid[x][y + 1][j], worldGrid[x][y + 2][g])
	updateWorld(false)

func applyRule(tile1, tile2, tile3) -> void:
	var affectedTile = tile1.tileName.split("_")[0]
	var operator = tile2.tileName.split("_")[0]
	var action = tile3.tileName.split("_")[0]
	var ifReplacement = tile3.tileName.split("_")[1] == "obj"
	if (operator == "is"):
		if (ifReplacement):
			if (ifRuleActive(affectedTile, "is", affectedTile)):
				return
			# todo replacement
		else:
			saveRule(affectedTile, operator, action)
	# todo more operators

func saveRule(tile_name, operator, action) -> void:
	if (!worldRules.has(tile_name)):
		worldRules[tile_name] = {}
	if (!worldRules[tile_name].has(operator)):
		worldRules[tile_name][operator] = {}
	if (!worldRules[tile_name][operator].has(action)):
		worldRules[tile_name][operator][action] = 1
	else:
		worldRules[tile_name][operator][action] += 1

func removeRule(tile_name, operator, action) -> void:
	worldRules[tile_name][operator][action] -= 1
	if (worldRules[tile_name][operator][action] == 0):
		worldRules[tile_name][operator].erase(action)
		if (worldRules[tile_name][operator].size() == 0):
			worldRules[tile_name].erase(operator)
			if (worldRules[tile_name].size() == 0):
				worldRules.erase(tile_name)

func ifRuleActive(tile_name, operator, action) -> bool:
	return worldRules.has(tile_name) && worldRules[tile_name].has(operator) && worldRules[tile_name][operator].has(action)

