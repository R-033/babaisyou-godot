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
	"baba": {"type": 0, "x": 0, "y": 0, "walkCycle": 4, "color": 21},
	"keke": {"type": 0, "x": 0, "y": 3, "walkCycle": 4, "color": 16},
	"baba_obj": {"type": 1, "x": 6, "y": 27, "walkCycle": 0, "color": 11},
	"keke_obj": {"type": 1, "x": 20, "y": 30, "walkCycle": 0, "color": 16},
	"is_op": {"type": 2, "x": 18, "y": 30, "walkCycle": 0, "color": 21},
	"pull_act": {"type": 3, "x": 1, "y": 42, "walkCycle": 0, "color": 20},
	"push_act": {"type": 3, "x": 2, "y": 42, "walkCycle": 0, "color": 13},
	"stop_act": {"type": 3, "x": 12, "y": 42, "walkCycle": 0, "color": 12},
	"win_act": {"type": 3, "x": 17, "y": 42, "walkCycle": 0, "color": 30},
	"you_act": {"type": 3, "x": 20, "y": 42, "walkCycle": 0, "color": 11},
}

func _ready():
	OS.set_window_size(Vector2(worldWidth * 24, worldHeight * 24))
	
	for x in range(worldWidth):
		worldGrid.append([])
		for y in range(worldHeight):
			worldGrid[x].append([])
	
	spawnTile(7, 7, 0, "baba")
	spawnTile(7, 9, 0, "keke")
	
	spawnTile(10, 1, 0, "keke_obj")
	spawnTile(9, 2, 0, "is_op")
	spawnTile(9, 3, 0, "push_act")
	spawnTile(10, 3, 0, "pull_act")
	
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
					if (i > worldGrid[x][y].size() - 1):
						i = 0
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
	var spawnedTile = tilePrefab.instance()
	add_child(spawnedTile)
	spawnedTile.main = self
	spawnedTile.updatePos(x, y)
	spawnedTile.direction = direction
	changeTileType(spawnedTile, name)
	worldGrid[x][y].append(spawnedTile)
	
func changeTileType(tile, name, forceLightUp = false) -> void:
	tile.tileName = name
	tile.tileType = tileDatabase[name]["type"]
	var color_x = tileDatabase[name]["color"]
	if (tile.tileType != 0 && !forceLightUp):
		color_x -= 7
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
	worldGrid[tile.pos.x][tile.pos.y].erase(tile)
	remove_child(tile)

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
	var affectedTile = tile1.tileName.split("_")[0]
	var operator = tile2.tileName.split("_")[0]
	var action = tile3.tileName.split("_")[0]
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

