extends Node

var loaded

var tiles = []
var worldRules = {}

var worldWidth = 15
var worldHeight = 13

var worldLerpTime = 1
var worldAnimationFrame = 0

var animtimer = 0

var unappliedMovement = null
var alreadyFinished

onready var tilePrefab = preload("res://src/tile.tscn")

var database
var loadedSprites = {}
var palette

func _ready():
	
	database = load("res://src/database.gd").tiles
	
	#loadLevel(0)
	
	loadPalette("default.png")
	
	spawnTileByName(1, 1, 0, "text_baba")
	spawnTileByName(2, 1, 0, "text_is")
	spawnTileByName(3, 1, 0, "text_you")
	
	spawnTileByName(1, 3, 0, "text_belt")
	spawnTileByName(2, 3, 0, "text_is")
	spawnTileByName(3, 3, 0, "text_shift")
	
	spawnTileByName(5, 3, 0, "text_box")
	spawnTileByName(6, 3, 0, "text_is")
	spawnTileByName(7, 3, 0, "text_push")
	
	spawnTileByName(7, 1, 0, "baba")
	spawnTileByName(9, 1, 0, "box")
	
	spawnTileByName(2, 5, 0, "belt")
	spawnTileByName(3, 5, 3, "belt")
	spawnTileByName(3, 6, 0, "belt")
	spawnTileByName(4, 6, 1, "belt")
	
	OS.set_window_size(Vector2(worldWidth * 24 * 2, worldHeight * 24 * 2))
	get_node("/root/root/Camera2D").position = Vector2(round(float(worldWidth * 24) / 2.0), round(float(worldHeight * 24) / 2.0))
	
	checkTheRules()
	
	for tile in tiles:
		if (tile.tilingMode == 1):
			applyAutoTile(tile)

func loadLevel(levelNum) -> void:
		
	var level = ConfigFile.new()
	var err = level.load("res://levels/" + str(levelNum) + "level.ld")
	if err == OK:
		
		loadPalette(level.get_value("general", "palette"))
		
		var changedTiles = level.get_value("tiles", "changed").split(",", false)
		for changedTile in changedTiles:
			if (!database.has(changedTile)):
				database[changedTile] = {}
			if (level.has_section_key(changedTile + "_image")):
				database[changedTile]["sprite"] = level.get_value(changedTile + "_image")
			if (level.has_section_key(changedTile + "_name")):
				database[changedTile]["name"] = level.get_value(changedTile + "_name")
			if (level.has_section_key(changedTile + "_unittype")):
				database[changedTile]["unittype"] = level.get_value(changedTile + "_unittype")
			if (level.has_section_key(changedTile + "_type")):
				database[changedTile]["type"] = level.get_value(changedTile + "_type")
			if (level.has_section_key(changedTile + "_tiling")):
				database[changedTile]["tiling"] = level.get_value(changedTile + "_tiling")
			if (level.has_section_key(changedTile + "_colour")):
				database[changedTile]["colour"] = level.get_value(changedTile + "_colour")
			if (level.has_section_key(changedTile + "_activecolour")):
				database[changedTile]["ative"] = level.get_value(changedTile + "_activecolour")
			if (level.has_section_key(changedTile + "_argextra")):
				database[changedTile]["argextra"] = level.get_value(changedTile + "_argextra")
			# perhaps more?

		var objectCount = level.get_value("general", "currobjlist_total")
		#for objectNum in range(1, objectCount + 1):
		#	var pos = [0, 0]
		#	var direction = 0
		#	spawnTile(pos[0], pos[1], direction, level.get_value("currobjlist", str(objectNum) + "object"))
	else:
		push_error("error loading level " + str(levelNum) + ": " + str(err))

func loadPalette(fileName) -> void:
	if (palette != null):
		palette.unlock()
	palette = load("res://palettes/" + fileName).get_data()
	palette.lock()
	VisualServer.set_default_clear_color(palette.get_pixel(6, 4))

func _process(delta):
	animtimer += delta
	if (animtimer > 0.2):
		animtimer -= 0.2
		worldAnimationFrame += 1
		if (worldAnimationFrame > 2):
			worldAnimationFrame = 0
		for tile in tiles:
			tile.updateSpriteAnim()
	if (worldLerpTime < 1):
		worldLerpTime += delta * 10
		if (worldLerpTime > 1):
			worldLerpTime = 1
	alreadyFinished = []

var palettes = ["default.png", "abstract.png", "autumn.png", "contrast.png", "factory.png", "garden.png", "marshmallow.png", "mono.png", "mountain.png", "ocean.png", "ruins.png", "space.png", "swamp.png", "test.png", "variant.png", "volcano.png"]
var curpal = 0

func _input(ev):
	if (worldLerpTime != 1):
		return
	if Input.is_key_pressed(KEY_P):
		curpal += 1
		if (curpal > palettes.size() - 1):
			curpal = 0
		loadPalette(palettes[curpal])
		for tile in tiles:
			changeTileType(tile, tile.tileId)
		checkTheRules()
	if Input.is_key_pressed(KEY_SPACE):
		unappliedMovement = Vector2.ZERO
	elif Input.is_key_pressed(KEY_RIGHT):
		unappliedMovement = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_UP):
		unappliedMovement = Vector2.UP
	elif Input.is_key_pressed(KEY_LEFT):
		unappliedMovement = Vector2.LEFT
	elif Input.is_key_pressed(KEY_DOWN):
		unappliedMovement = Vector2.DOWN
	if (unappliedMovement != null):
		worldLerpTime = 0
		updateWorld()
		checkTheRules()

func spawnTileByName(x, y, direction, tileName) -> void:
	spawnTile(x, y, direction, findTileId(tileName))

func spawnTile(x, y, direction, name) -> void:
	var spawnedTile = tilePrefab.instance()
	add_child(spawnedTile)
	spawnedTile.main = self
	spawnedTile.direction = direction
	changeTileType(spawnedTile, name)
	spawnedTile.updatePos(x, y)
	spawnedTile.position = Vector2(x, y) * 24
	tiles.append(spawnedTile)
	
func changeTileType(tile, name, forceLightUp = false) -> void:
	
	tile.tileName = database[name]["name"]
	tile.tileId = name
	
	var rawType = database[name]["type"]
	if (rawType == 0):
		if (database[name]["unittype"] == "text"):
			rawType = 1
	elif (rawType == 7):
		rawType = 4
	elif (rawType == 1):
		rawType = 2
	elif (rawType == 2):
		rawType = 3
	else:
		push_error("unknown tile type " + str(rawType) + " (" + tile.tileName + ")")
	
	tile.tileType = rawType
	tile.tilingMode = database[name]["tiling"]
	
	if (tile.tilingMode != 1):
		tile.autoTileValue = 0
	
	if (!loadedSprites.has(name)):
		loadedSprites[name] = []
		var spriteName = database[name]["sprite"]
		loadSprite(name, spriteName + "_0")
		if (tile.tilingMode == 3):
			for i in [0, 1, 2, 3, 8, 9, 10, 11, 16, 17, 18, 19, 24, 25, 26, 27]:
				loadSprite(name, spriteName + "_" + str(i))
		elif (tile.tilingMode == 2):
			for i in [1, 2, 3, 7, 8, 9, 10, 16, 17, 18, 19, 24, 25, 26, 27, 11, 15, 23, 31]:
				loadSprite(name, spriteName + "_" + str(i))
		elif (tile.tilingMode == 1):
			for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]:
				loadSprite(name, spriteName + "_" + str(i))
		elif (tile.tilingMode != -1):
			push_error("tiling mode " + str(tile.tilingMode) + " is not implemented (" + tile.tileName + ")")
	
	var color
	if (tile.tileType == 0 || !forceLightUp):
		color = palette.get_pixel(database[name]["colour"][0], database[name]["colour"][1])
	else:
		color = palette.get_pixel(database[name]["active"][0], database[name]["active"][1])
	tile.updateSpriteColor(color)
	
	tile.z_index = database[name]["layer"]

func loadSprite(name, spriteName) -> void:
	loadedSprites[name].append([load("res://sprites/" + spriteName + "_1.png"), load("res://sprites/" + spriteName + "_2.png"), load("res://sprites/" + spriteName + "_3.png")])

func destroyTile(tile) -> void:
	var hasReplacement = ifOperatorUsed(tile.tileName, "has")
	if (hasReplacement != ""):
		changeTileType(tile, findTileId(hasReplacement))
	else:
		tiles.erase(tile)
		remove_child(tile)

func findTileId(name) -> String:
	for key in database.keys():
		if (database[key]["name"] == name):
			return key
	push_error("tile " + str(name) + " doesn't exist")
	return ""

func getForward(tile) -> Vector2:
	if (tile.direction == 0):
		return Vector2.RIGHT
	if (tile.direction == 1):
		return Vector2.UP
	if (tile.direction == 2):
		return Vector2.LEFT
	return Vector2.DOWN

func updateWorld() -> void:
	alreadyFinished = []
	var justTeleported = []
	var justShifted = []
	for tile in tiles:
		if (tile.tilingMode == 3):
			tile.updateWalkFrame()
			tile.updateSpriteAnim()
		if (unappliedMovement != null && ifRuleActive(tile.tileName, "is", "you")):
			push_tile(tile, unappliedMovement.x, unappliedMovement.y)
		if (ifRuleActive(tile.tileName, "is", "move")):
			var forward = getForward(tile)
			var success = push_tile(tile, forward.x, forward.y)
			if (!success):
				tile.direction = 2 if (tile.direction == 0) else 0 if (tile.direction == 2) else 1 if (tile.direction == 3) else 3
				tile.updateSpriteAnim()
				forward = getForward(tile)
				push_tile(tile, forward.x, forward.y)
		if (ifRuleActive(tile.tileName, "is", "fall")):
			yeet_tile(tile, 0, 1)
		if (ifRuleActive(tile.tileName, "is", "tele")):
			var needsToBeTeleported = []
			var nextInstance = null
			for subtile in tiles:
				if (subtile == tile):
					continue
				if (nextInstance == null && subtile.tileId == tile.tileId):
					nextInstance = subtile
				elif (!justTeleported.has(subtile) && subtile.pos == tile.pos):
					needsToBeTeleported.append(subtile)
			for subtile in needsToBeTeleported:
				subtile.updatePos(nextInstance.pos.x, nextInstance.pos.y)
				justTeleported.append(subtile)
		if (ifRuleActive(tile.tileName, "is", "shift")):
			var needsToBePushed = []
			var forward = getForward(tile)
			for subtile in tiles:
				if (subtile == tile):
					continue
				if (!justShifted.has(subtile) && subtile.pos == tile.pos):
					needsToBePushed.append(subtile)
			for subtile in needsToBePushed:
				if (push_tile(subtile, forward.x, forward.y)):
					justShifted.append(subtile)
	unappliedMovement = null

func applyAutoTile(tile) -> void:
	var left = false
	var right = false
	var top = false
	var bottom = false
	for subTile in tiles:
		if (subTile.tileName == tile.tileName):
			if (subTile.pos.x == tile.pos.x - 1 && subTile.pos.y == tile.pos.y):
				left = true
			elif (subTile.pos.x == tile.pos.x + 1 && subTile.pos.y == tile.pos.y):
				right = true
			elif (subTile.pos.x == tile.pos.x && subTile.pos.y == tile.pos.y - 1):
				top = true
			elif (subTile.pos.x == tile.pos.x && subTile.pos.y == tile.pos.y + 1):
				bottom = true
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

func yeet_tile(tile, delta_x, delta_y) -> void:
	while (true):
		if (!push_tile(tile, delta_x, delta_y)):
			return;

func push_tile(tile, delta_x, delta_y) -> bool:
	if (ifRuleActive(tile.tileName, "is", "fall") && delta_y < 0):
		return false
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	var oppositeX = tile.pos.x - delta_x
	var oppositeY = tile.pos.y - delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	var pushableTiles = []
	var pullableTiles = []
	for pushedTile in tiles:
		if (alreadyFinished.has(pushedTile)):
			continue
		if (pushedTile.pos.x == newX && pushedTile.pos.y == newY):
			if (is_tile_solid(pushedTile)):
				if (!can_be_pushed(pushedTile, delta_x, delta_y)):
					return false
				pushableTiles.append(pushedTile)
		elif (pushedTile.pos.x == oppositeX && pushedTile.pos.y == oppositeY):
			if (is_tile_solid(pushedTile)):
				if (!can_be_pulled(pushedTile, delta_x, delta_y)):
					continue
				pullableTiles.append(pushedTile)
	for pushedTile in pushableTiles:
		push_tile(pushedTile, delta_x, delta_y)
	for pulledTile in pullableTiles:
		pull_tile(pulledTile, delta_x, delta_y)
	tile.updatePos(newX, newY)
	if (tile.tilingMode == 1):
		applyAutoTile(tile)
	alreadyFinished.append(tile)
	return true

func pull_tile(tile, delta_x, delta_y) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	var oppositeX = tile.pos.x - delta_x
	var oppositeY = tile.pos.y - delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	var pullableTiles = []
	for pushedTile in tiles:
		if (alreadyFinished.has(pushedTile)):
			continue
		if (pushedTile.pos.x == oppositeX && pushedTile.pos.y == oppositeY):
			if (is_tile_solid(pushedTile)):
				if (!can_be_pulled(pushedTile, delta_x, delta_y)):
					continue
				pullableTiles.append(pushedTile)
	for pulledTile in pullableTiles:
		pull_tile(pulledTile, delta_x, delta_y)
	tile.updatePos(newX, newY)
	if (tile.tilingMode == 1):
		applyAutoTile(tile)
	alreadyFinished.append(tile)
	return true

func can_be_pushed(tile, delta_x, delta_y) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (ifRuleActive(tile.tileName, "is", "stop")):
		return false
	if (tile.tileType == 0 && !ifRuleActive(tile.tileName, "is", "push")):
		return false
	for pushedTile in tiles:
		if (pushedTile.pos.x == newX && pushedTile.pos.y == newY):
			if (is_tile_solid(pushedTile)):
				if (!can_be_pushed(pushedTile, delta_x, delta_y)):
					return false
	return true

func can_be_pulled(tile, delta_x, delta_y) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (ifRuleActive(tile.tileName, "is", "stop")):
		return false
	if (!ifRuleActive(tile.tileName, "is", "pull")):
		return false
	return true

func is_tile_solid(tile) -> bool:
	if (tile.tileType != 0):
		return true
	if (ifRuleActive(tile.tileName, "is", "push")):
		return true
	if (ifRuleActive(tile.tileName, "is", "pull")):
		return true
	if (ifRuleActive(tile.tileName, "is", "stop")):
		return true
	return false

func checkTheRules() -> void:
	worldRules.clear()
	for tile in tiles:
		if (tile.tileType != 0):
			changeTileType(tile, tile.tileId)
	for tile in tiles:
		if (tile.tileType == 1):
			checkTileRules(tile)

func checkTileRules(tile) -> void:
	for secondTile in tiles:
		if (secondTile.pos.x == tile.pos.x + 1 && secondTile.pos.y == tile.pos.y):
			if (secondTile.tileType == 2):
				for thirdTile in tiles:
					if (thirdTile.pos.x == tile.pos.x + 2 && thirdTile.pos.y == tile.pos.y):
						if (thirdTile.tileType == 3 || thirdTile.tileType == 1):
							applyRule(tile, secondTile, thirdTile)
		if (secondTile.pos.x == tile.pos.x && secondTile.pos.y == tile.pos.y + 1):
			if (secondTile.tileType == 2):
				for thirdTile in tiles:
					if (thirdTile.pos.x == tile.pos.x && thirdTile.pos.y == tile.pos.y + 2):
						if (thirdTile.tileType == 3 || thirdTile.tileType == 1):
							applyRule(tile, secondTile, thirdTile)

func applyRule(tile1, tile2, tile3) -> void:
	var affectedTile = tile1.tileName.split("_")[1]
	var operator = tile2.tileName.split("_")[1]
	var action = tile3.tileName.split("_")[1]
	var ifReplacement = tile3.tileType == 1
	if (operator == "is"):
		if (ifReplacement):
			if (ifRuleActive(affectedTile, "is", affectedTile)):
				return
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					changeTileType(subTile, findTileId(action))
					subTile.updateSpriteAnim()
	saveRule(affectedTile, operator, action)
	changeTileType(tile1, tile1.tileId, true)
	changeTileType(tile2, tile2.tileId, true)
	changeTileType(tile3, tile3.tileId, true)

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