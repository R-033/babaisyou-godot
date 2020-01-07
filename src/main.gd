extends Node

var worldGrid = []
var worldRules = {}
var worldWidth = 11
var worldHeight = 9

var worldLerpTime = 1
var worldAnimationFrame = 0

var worldColorPalette = 0

var animtimer = 0

var unappliedMovement = null

onready var tilePrefab = preload("res://src/tile.tscn")

var tileDatabase = {
	"baba": {"type": 0, "x": 0, "y": 0, "walkCycle": 4, "color": 21}, # works
	"keke": {"type": 0, "x": 0, "y": 3, "walkCycle": 4, "color": 16}, # works
	"flag": {"type": 0, "x": 6, "y": 21, "color": 30}, # works
	"rock": {"type": 0, "x": 15, "y": 21, "color": 20}, # works
	"floor": {"type": 0, "x": 19, "y": 21, "color": 1}, # works, name is guessed
	"text_and": {"type": 2, "x": 3, "y": 27, "color": 11},
	"text_baba": {"type": 1, "x": 6, "y": 27, "color": 11}, # works
	"text_facing": {"type": 2, "x": 29, "y": 27, "color": 21},
	"text_flag": {"type": 1, "x": 1, "y": 30, "color": 30}, # works
	"text_has": {"type": 2, "x": 12, "y": 30, "color": 21}, # testing
	"text_is": {"type": 2, "x": 18, "y": 30, "color": 21}, # works
	"text_keke": {"type": 1, "x": 20, "y": 30, "color": 16}, # works
	"text_lonely": {"type": 2, "x": 27, "y": 30, "color": 16},
	"text_make": {"type": 2, "x": 29, "y": 30, "color": 21},
	"text_near": {"type": 2, "x": 0, "y": 33, "color": 11},
	"text_not": {"type": 2, "x": 1, "y": 33, "color": 16},
	"text_on": {"type": 2, "x": 3, "y": 33, "color": 11},
	"text_rock": {"type": 1, "x": 11, "y": 33, "color": 20}, # works
	"text_wall": {"type": 1, "x": 27, "y": 33, "color": 7}, # works
	"text_pull": {"type": 3, "x": 1, "y": 42, "color": 20}, # works
	"text_push": {"type": 3, "x": 2, "y": 42, "color": 13}, # works
	"text_stop": {"type": 3, "x": 12, "y": 42, "color": 12}, # works
	"text_win": {"type": 3, "x": 17, "y": 42, "color": 30},
	"text_you": {"type": 3, "x": 20, "y": 42, "color": 11}, # works
	"wall": {"type": 1, "x": 0, "y": 57, "autoTiled": 1, "color": 8}, # testing
}

func _ready():
	OS.set_window_size(Vector2(worldWidth * 24 * 2, worldHeight * 24 * 2))
	
	for x in range(worldWidth):
		worldGrid.append([])
		for y in range(worldHeight):
			worldGrid[x].append([])
	
	spawnTile(0, 0, 0, "text_baba")
	spawnTile(1, 0, 0, "text_is")
	spawnTile(2, 0, 0, "text_you")
	
	spawnTile(8, 0, 0, "text_flag")
	spawnTile(9, 0, 0, "text_is")
	spawnTile(10, 0, 0, "text_win")
	
	for x in range(11):
		spawnTile(x, 2, 0, "wall")
	
	for x in range(11):
		for y in range(3):
			if (x == 1 && y == 1 || x == 9 && y == 1 || x == 5):
				continue
			spawnTile(x, 3 + y, 0, "floor")
	
	spawnTile(1, 4, 0, "baba")
	
	spawnTile(5, 3, 0, "rock")
	spawnTile(5, 4, 0, "rock")
	spawnTile(5, 5, 0, "rock")
	
	spawnTile(9, 4, 0, "flag")
	
	for x in range(11):
		spawnTile(x, 6, 0, "wall")
	
	spawnTile(0, 8, 0, "text_wall")
	spawnTile(1, 8, 0, "text_is")
	spawnTile(2, 8, 0, "text_stop")
	
	spawnTile(8, 8, 0, "text_rock")
	spawnTile(9, 8, 0, "text_is")
	spawnTile(10, 8, 0, "text_push")
	
	checkTheRules()
	
	for x in range(worldWidth):
		for y in range(worldHeight):
			for i in range(worldGrid[x][y].size()):
				if (worldGrid[x][y][i].autoTiled):
					applyAutoTile(worldGrid[x][y][i])

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

func _input(ev):
	if (worldLerpTime != 1):
		return
	if Input.is_key_pressed(KEY_SPACE):
		unappliedMovement = Vector2(0, 0)
	elif Input.is_key_pressed(KEY_RIGHT):
		unappliedMovement = Vector2(1, 0)
	elif Input.is_key_pressed(KEY_UP):
		unappliedMovement = Vector2(0, -1)
	elif Input.is_key_pressed(KEY_LEFT):
		unappliedMovement = Vector2(-1, 0)
	elif Input.is_key_pressed(KEY_DOWN):
		unappliedMovement = Vector2(0, 1)
	if (unappliedMovement != null):
		worldLerpTime = 0
		updateWorld()
		checkTheRules()

func spawnTile(x, y, direction, name) -> void:
	if (!tileDatabase.has(name)):
		return
	var spawnedTile = tilePrefab.instance()
	add_child(spawnedTile)
	spawnedTile.main = self
	spawnedTile.updatePos(x, y)
	spawnedTile.direction = direction
	changeTileType(spawnedTile, name)
	worldGrid[x][y].append(spawnedTile)
	
func changeTileType(tile, name, forceLightUp = false) -> void:
	if (!tileDatabase.has(name)):
		return
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
	if (tile.tileType != 0 && !forceLightUp):
		color *= 0.8
	tile.updateSprite(tileDatabase[name]["x"], tileDatabase[name]["y"], tileDatabase[name]["walkCycle"] if tileDatabase[name].has("walkCycle") else 0, color)
	if (tileDatabase[name].has("alwaysWalk") && tileDatabase[name]["alwaysWalk"] == 1):
		tile.alwaysUpdateWalkFrame = true
	if (tileDatabase[name].has("autoTiled") && tileDatabase[name]["autoTiled"] == 1):
		tile.autoTiled = true

func destroyTile(tile) -> void:
	var hasReplacement = ifOperatorUsed(tile.tileName, "has")
	if (hasReplacement != ""):
		changeTileType(tile, hasReplacement)
	else:
		worldGrid[tile.pos.x][tile.pos.y].erase(tile)
		remove_child(tile)

func updateWorld() -> void:
	var alreadyFinished = []
	for x in range(worldWidth):
		for y in range(worldHeight):
			for i in range(worldGrid[x][y].size()):
				if (i > worldGrid[x][y].size() - 1):
					i = 0
				var tile = worldGrid[x][y][i]
				if (alreadyFinished.has(tile)):
					continue
				if (tile.alwaysUpdateWalkFrame):
					tile.updatePos(x, y)
				if (unappliedMovement != null && ifRuleActive(worldGrid[x][y][i].tileName, "is", "you")):
					push_tile(tile, unappliedMovement.x, unappliedMovement.y, alreadyFinished)
				# todo apply rules and stuff
	unappliedMovement = null

func applyAutoTile(tile) -> void:
	var left = false
	var right = false
	var top = false
	var bottom = false
	if (tile.pos.x > 0):
		for i in range(worldGrid[tile.pos.x - 1][tile.pos.y].size()):
			if (worldGrid[tile.pos.x - 1][tile.pos.y][i].tileName == tile.tileName):
				left = true
				break
	if (tile.pos.x < worldWidth - 1):
		for i in range(worldGrid[tile.pos.x + 1][tile.pos.y].size()):
			if (worldGrid[tile.pos.x + 1][tile.pos.y][i].tileName == tile.tileName):
				right = true
				break
	if (tile.pos.y > 0):
		for i in range(worldGrid[tile.pos.x][tile.pos.y - 1].size()):
			if (worldGrid[tile.pos.x][tile.pos.y - 1][i].tileName == tile.tileName):
				top = true
				break
	if (tile.pos.y < worldHeight - 1):
		for i in range(worldGrid[tile.pos.x][tile.pos.y + 1].size()):
			if (worldGrid[tile.pos.x][tile.pos.y + 1][i].tileName == tile.tileName):
				bottom = true
				break
	if (left):
		if (bottom):
			if (top):
				if (right):
					tile.autoTileValue = 15
					return
				tile.autoTileValue = 14
				return
			if (right):
				tile.autoTileValue = 13
				return
			tile.autoTileValue = 12
			return
		if (top):
			if (right):
				tile.autoTileValue = 7
				return
			tile.autoTileValue = 6
			return
		if (right):
			tile.autoTileValue = 5
			return
		tile.autoTileValue = 4
		return
	if (bottom):
		if (top):
			if (right):
				tile.autoTileValue = 11
				return
			tile.autoTileValue = 10
			return
		if (right):
			tile.autoTileValue = 9
			return
		tile.autoTileValue = 8
		return
	if (top):
		if (right):
			tile.autoTileValue = 3
			return
		tile.autoTileValue = 2
		return
	if (right):
		tile.autoTileValue = 1
		return
	tile.autoTileValue = 0

func push_tile(tile, delta_x, delta_y, alreadyFinished) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	var oppositeX = tile.pos.x - delta_x
	var oppositeY = tile.pos.y - delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	for j in range(worldGrid[newX][newY].size()):
		var pushedTile = worldGrid[newX][newY][j]
		if (is_tile_solid(pushedTile)):
			if (!can_be_pushed(pushedTile, delta_x, delta_y)):
				return false
	var alreadyFinishedSub = []
	for j in range(worldGrid[newX][newY].size()):
		if (j > worldGrid[newX][newY].size() - 1):
			j = 0
		var pushedTile = worldGrid[newX][newY][j]
		if (alreadyFinished.has(pushedTile)):
			continue
		if (is_tile_solid(pushedTile)):
			push_tile(pushedTile, delta_x, delta_y, alreadyFinishedSub)
	if (oppositeX > 0 && oppositeX < worldWidth - 1 && oppositeY > 0 && oppositeY < worldHeight - 1):
		alreadyFinishedSub = []
		for j in range(worldGrid[oppositeX][oppositeY].size()):
			if (j > worldGrid[oppositeX][oppositeY].size() - 1):
				j = 0
			var pulledTile = worldGrid[oppositeX][oppositeY][j]
			if (alreadyFinished.has(pulledTile)):
				continue
			if (ifRuleActive(pulledTile.tileName, "is", "pull")):
				push_tile(pulledTile, delta_x, delta_y, alreadyFinishedSub)
	worldGrid[tile.pos.x][tile.pos.y].erase(tile)
	tile.updatePos(newX, newY)
	if (tile.autoTiled):
		applyAutoTile(tile)
	worldGrid[newX][newY].append(tile)
	if (alreadyFinished != null):
		alreadyFinished.append(tile)
	return true

func can_be_pushed(tile, delta_x, delta_y) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (ifRuleActive(tile.tileName, "is", "stop")):
		return false
	if (ifRuleActive(tile.tileName, "is", "pull")):
		return false
	for j in range(worldGrid[newX][newY].size()):
		var pushedTile = worldGrid[newX][newY][j]
		if (is_tile_solid(pushedTile)):
			if (!can_be_pushed(pushedTile, delta_x, delta_y)):
				return false
	return true

func is_tile_solid(tile) -> bool:
	if (tile.tileType != 0):
		return true
	if (ifRuleActive(tile.tileName, "is", "push")):
		return true
	if (ifRuleActive(tile.tileName, "is", "pull")):
		return true
	return false

func checkTheRules() -> void:
	worldRules.clear()
	for x in range(worldWidth):
		for y in range(worldHeight):
			for i in range(worldGrid[x][y].size()):
				if (worldGrid[x][y][i].tileType != 0):
					changeTileType(worldGrid[x][y][i], worldGrid[x][y][i].tileName)
	for x in range(worldWidth):
		for y in range(worldHeight):
			for i in range(worldGrid[x][y].size()):
				if (worldGrid[x][y][i].tileType == 1):
					checkTileRules(worldGrid[x][y][i])

func checkTileRules(tile) -> void:
	if (tile.pos.x < worldWidth - 2):
		for j in range(worldGrid[tile.pos.x + 1][tile.pos.y].size()):
			if (worldGrid[tile.pos.x + 1][tile.pos.y][j].tileType == 2):
				for g in range(worldGrid[tile.pos.x + 2][tile.pos.y].size()):
					if (worldGrid[tile.pos.x + 2][tile.pos.y][g].tileType == 3 || worldGrid[tile.pos.x + 2][tile.pos.y][g].tileType == 1):
						applyRule(tile, worldGrid[tile.pos.x + 1][tile.pos.y][j], worldGrid[tile.pos.x + 2][tile.pos.y][g])
	if (tile.pos.y < worldHeight - 2):
		for j in range(worldGrid[tile.pos.x][tile.pos.y + 1].size()):
			if (worldGrid[tile.pos.x][tile.pos.y + 1][j].tileType == 2):
				for g in range(worldGrid[tile.pos.x][tile.pos.y + 2].size()):
					if (worldGrid[tile.pos.x][tile.pos.y + 2][g].tileType == 3 || worldGrid[tile.pos.x][tile.pos.y + 2][g].tileType == 1):
						applyRule(tile, worldGrid[tile.pos.x][tile.pos.y + 1][j], worldGrid[tile.pos.x][tile.pos.y + 2][g])

func applyRule(tile1, tile2, tile3) -> void:
	var affectedTile = tile1.tileName.split("_")[1]
	var operator = tile2.tileName.split("_")[1]
	var action = tile3.tileName.split("_")[1]
	var ifReplacement = tile3.tileType == 1
	if (operator == "is"):
		if (ifReplacement):
			if (ifRuleActive(affectedTile, "is", affectedTile)):
				return
			for x in range(worldWidth):
				for y in range(worldHeight):
					for i in range(worldGrid[x][y].size()):
						if (worldGrid[x][y][i].tileName == affectedTile):
							changeTileType(worldGrid[x][y][i], action)
	saveRule(affectedTile, operator, action)
	changeTileType(tile1, tile1.tileName, true)
	changeTileType(tile2, tile2.tileName, true)
	changeTileType(tile3, tile3.tileName, true)

func saveRule(tile_name, operator, action) -> void:
	if (!worldRules.has(tile_name)):
		worldRules[tile_name] = {}
	if (!worldRules[tile_name].has(operator)):
		worldRules[tile_name][operator] = {}
	if (!worldRules[tile_name][operator].has(action)):
		worldRules[tile_name][operator][action] = 1
	else:
		worldRules[tile_name][operator][action] += 1

func ifRuleActive(tile_name, operator, action) -> bool:
	return (worldRules.has(tile_name) || worldRules.has(tile_name + "2") || worldRules.has(tile_name + "3")) && worldRules[tile_name].has(operator) && worldRules[tile_name][operator].has(action)

func ifOperatorUsed(tile_name, operator) -> String:
	if (worldRules.has(tile_name) && worldRules[tile_name].has(operator)):
		return worldRules[tile_name][operator][worldRules[tile_name][operator].keys()[0]]
	return ""