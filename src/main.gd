extends Node

# todo float
# fix more
# todo red
# todo blue
# todo all
# todo and
# todo not
# todo turn
# todo deturn
# todo still

var loaded

var tiles = []
var worldRules = {}

var worldWidth = 27
var worldHeight = 23

var worldLerpTime = 1
var worldAnimationFrame = 0

var animtimer = 0

var unappliedMovement = null
var unappliedRules = false
var alreadyFinished

onready var tilePrefab = preload("res://src/tile.tscn")

var database
var loadedSprites = {}
var palette

var controlsActive = true

var startTime = OS.get_ticks_msec()
var curTime = startTime

func test_pong() -> void:
	spawnTileByName(0, 0, 0, "text_orb")
	spawnTileByName(1, 0, 0, "text_is")
	spawnTileByName(2, 0, 0, "text_move")
	
	spawnTileByName(0, 1, 0, "text_tile")
	spawnTileByName(1, 1, 0, "text_on")
	spawnTileByName(2, 1, 0, "text_orb")
	spawnTileByName(3, 1, 0, "text_is")
	spawnTileByName(4, 1, 0, "text_shift")
	
	spawnTileByName(0, 2, 0, "text_text")
	spawnTileByName(1, 2, 0, "text_on")
	spawnTileByName(2, 2, 0, "text_tile")
	spawnTileByName(3, 2, 0, "text_is")
	spawnTileByName(4, 2, 0, "text_swap")
	
	spawnTileByName(0, 3, 0, "text_tile")
	spawnTileByName(1, 3, 0, "text_near")
	spawnTileByName(2, 3, 0, "text_me")
	spawnTileByName(3, 3, 0, "text_is")
	spawnTileByName(4, 3, 0, "text_stop")

	spawnTileByName(6, 0, 0, "text_baba")
	spawnTileByName(7, 0, 0, "text_not")
	spawnTileByName(8, 0, 0, "text_on")
	spawnTileByName(9, 0, 0, "text_grass")
	spawnTileByName(10, 0, 0, "text_is")
	spawnTileByName(11, 0, 0, "text_defeat")
	
	spawnTileByName(6, 1, 0, "text_baba")
	spawnTileByName(7, 1, 0, "text_is")
	spawnTileByName(8, 1, 0, "text_you")
	spawnTileByName(9, 1, 0, "text_and")
	spawnTileByName(10, 1, 0, "text_stop")
	
	spawnTileByName(6, 2, 0, "text_keke")
	spawnTileByName(7, 2, 0, "text_is")
	spawnTileByName(8, 2, 0, "text_move")
	spawnTileByName(9, 2, 0, "text_and")
	spawnTileByName(10, 2, 0, "text_stop")

	spawnTileByName(13, 0, 0, "text_orb")
	spawnTileByName(14, 0, 0, "text_near")
	spawnTileByName(15, 0, 0, "text_grass")
	spawnTileByName(16, 0, 0, "text_and")
	spawnTileByName(17, 0, 0, "text_not")
	spawnTileByName(18, 0, 0, "text_near")
	spawnTileByName(19, 0, 0, "text_baba")
	spawnTileByName(20, 0, 0, "text_is")
	spawnTileByName(21, 0, 0, "text_love")
	
	spawnTileByName(13, 1, 0, "text_orb")
	spawnTileByName(14, 1, 0, "text_near")
	spawnTileByName(15, 1, 0, "text_brick")
	spawnTileByName(16, 1, 0, "text_and")
	spawnTileByName(17, 1, 0, "text_not")
	spawnTileByName(18, 1, 0, "text_near")
	spawnTileByName(19, 1, 0, "text_keke")
	spawnTileByName(20, 1, 0, "text_is")
	spawnTileByName(21, 1, 0, "text_dust")
	
	spawnTileByName(23, 0, 0, "text_level")
	spawnTileByName(23, 1, 0, "text_is")
	spawnTileByName(23, 2, 0, "text_shut")
	
	spawnTileByName(24, 0, 0, "text_love")
	spawnTileByName(24, 1, 0, "text_is")
	spawnTileByName(24, 2, 0, "text_open")
	
	spawnTileByName(25, 0, 0, "text_me")
	spawnTileByName(25, 1, 0, "text_is")
	spawnTileByName(25, 2, 0, "text_move")
	
	spawnTileByName(26, 0, 0, "text_wall")
	spawnTileByName(26, 1, 0, "text_is")
	spawnTileByName(26, 2, 0, "text_stop")
	
	spawnTileByName(22, 3, 0, "text_dust")
	spawnTileByName(23, 3, 0, "text_is")
	spawnTileByName(24, 3, 0, "text_you")
	spawnTileByName(25, 3, 0, "text_and")
	spawnTileByName(26, 3, 0, "text_win")
	
	spawnTileByName(1, 19, 0, "text_tile")
	spawnTileByName(2, 19, 0, "text_is")
	spawnTileByName(3, 19, 0, "text_right")
	spawnTileByName(4, 19, 0, "text_left")
	
	spawnTileByName(1, 20, 0, "text_text")
	spawnTileByName(2, 20, 0, "text_is")
	spawnTileByName(3, 20, 0, "text_right")
	spawnTileByName(4, 20, 0, "text_left")
	
	for x in range(1, 4):
		spawnTileByName(x, 21, 0, "tile")
	
	spawnTileByName(1, 22, 0, "text_orb")
	spawnTileByName(2, 22, 0, "text_is")
	spawnTileByName(3, 22, 0, "text_up")
	spawnTileByName(4, 22, 0, "text_down")
	
	spawnTileByName(15, 19, 2, "me")
	spawnTileByName(15, 20, 2, "me")
	spawnTileByName(10, 22, 2, "me")
	
	for x in range(0, worldWidth):
		spawnTileByName(x, 4, 0, "wall")
		
	for y in range(5, worldHeight):
		spawnTileByName(0, y, 0, "wall")
		spawnTileByName(worldWidth - 1, y, 0, "wall")
		
	for x in range(1, worldWidth - 1):
		spawnTileByName(x, 18, 0, "wall")
	
	for x in range(17, worldWidth - 1):
		for y in range(19, worldHeight):
			spawnTileByName(x, y, 0, "wall")
	
	for x in range(12, 17):
		for y in range(21, worldHeight):
			spawnTileByName(x, y, 0, "wall")
			
	for x in range(2, worldWidth - 2):
		for y in range(5, 18):
			spawnTileByName(x, y, 0, "tile")
			
	for y in range(5, 18):
		spawnTileByName(1, y, 0, "grass")
		spawnTileByName(worldWidth - 2, y, 0, "brick")
	
	spawnTileByName(1, 6, 3, "baba")
	spawnTileByName(1, 7, 3, "baba")
	spawnTileByName(1, 8, 3, "baba")
	
	spawnTileByName(worldWidth - 2, 11, 3, "keke")
	spawnTileByName(worldWidth - 2, 12, 3, "keke")
	spawnTileByName(worldWidth - 2, 13, 3, "keke")
	spawnTileByName(worldWidth - 2, 14, 3, "keke")
	spawnTileByName(worldWidth - 2, 15, 3, "keke")
	
	spawnTileByName(14, 10, 0, "orb")

func _ready():
	
	database = load("res://src/database.gd").tiles
	
	#loadLevel(0)
	
	loadPalette("default.png")
	
	test_pong()
	
	var cam = get_node("/root/root/Camera2D")
	cam.position = Vector2(round(float(worldWidth * 24) / 2.0), round(float(worldHeight * 24) / 2.0))
	var display_size = OS.get_screen_size()
	var zoom = clamp(max(worldWidth, worldHeight) / (min(display_size.x, display_size.y) / 22), 0.5, 1)
	cam.zoom = Vector2.ONE * zoom
	OS.set_window_size(Vector2(worldWidth * 24 * (1 / zoom), worldHeight * 24 * (1 / zoom)))
	
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
	curTime = OS.get_ticks_msec() - startTime
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
		if (worldLerpTime >= 1):
			worldLerpTime = 1
	alreadyFinished = []

var palettes = ["default.png", "abstract.png", "autumn.png", "contrast.png", "factory.png", "garden.png", "marshmallow.png", "mono.png", "mountain.png", "ocean.png", "ruins.png", "space.png", "swamp.png", "test.png", "variant.png", "volcano.png"]
var curpal = 0

func _input(ev):
	if (worldLerpTime != 1 || !controlsActive):
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
		if (unappliedRules):
			unappliedRules = false
			checkTheRules()

func spawnTileByName(x, y, direction, tileName) -> void:
	spawnTile(x, y, direction, findTileId(tileName))

func spawnTile(x, y, direction, name) -> Node:
	var spawnedTile = tilePrefab.instance()
	add_child(spawnedTile)
	spawnedTile.main = self
	spawnedTile.direction = direction
	changeTileType(spawnedTile, name)
	spawnedTile.updatePos(x, y)
	spawnedTile.position = Vector2(x, y) * 24
	tiles.append(spawnedTile)
	return spawnedTile
	
func changeTileType(tile, name, forceLightUp = false) -> void:
	
	tile.tileName = database[name]["name"]
	tile.tileId = name
	
	tile.isFloating = ifRuleActive(tile.tileName, "is", "float")
	
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
			for i in [1, 2, 3, 8, 9, 10, 11, 16, 17, 18, 19, 24, 25, 26, 27]:
				loadSprite(name, spriteName + "_" + str(i))
		elif (tile.tilingMode == 2):
			for i in [1, 2, 3, 7, 8, 9, 10, 16, 17, 18, 19, 24, 25, 26, 27, 31, 11, 15, 23]:
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

func destroyTile(tile, forced = false) -> void:
	if (!forced && ifRuleActive(tile.tileName, "is", "safe")):
		return
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
	var justSpawned = []
	for tile in tiles:
		if (tile.tilingMode == 3):
			tile.updateWalkFrame()
			tile.updateSpriteAnim()
		if (ifOperatorUsed(tile.tileName, "is")):
			tile.isFloating = ifPropertyUsed(tile.tileName, "is", "float")
			tile.isSleeping = ifPropertyUsed(tile.tileName, "is", "sleep")
			tile.visible = !ifPropertyUsed(tile.tileName, "is", "hide")
			if (unappliedMovement != null && ifPropertyUsed(tile.tileName, "is", "you") && !tile.isSleeping && unappliedMovement != Vector2.ZERO):
				if (ifPropertyUsed(tile.tileName, "is", "up")):
					push_tile(tile, 0, -1)
				elif (ifPropertyUsed(tile.tileName, "is", "down")):
					push_tile(tile, 0, 1)
				elif (ifPropertyUsed(tile.tileName, "is", "left")):
					push_tile(tile, -1, 0)
				elif (ifPropertyUsed(tile.tileName, "is", "right")):
					push_tile(tile, 1, 0)
				else:
					push_tile(tile, unappliedMovement.x, unappliedMovement.y)
		else:
			tile.isFloating = false
			tile.isSleeping = false
			tile.visible = true
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "move") && !tile.isSleeping):
				for i in range(0, worldRules[tile.tileName]["is"]["move"]):
					if (ifPropertyUsed(tile.tileName, "is", "up")):
						push_tile(tile, 0, -1)
					elif (ifPropertyUsed(tile.tileName, "is", "down")):
						push_tile(tile, 0, 1)
					elif (ifPropertyUsed(tile.tileName, "is", "left")):
						push_tile(tile, -1, 0)
					elif (ifPropertyUsed(tile.tileName, "is", "right")):
						push_tile(tile, 1, 0)
					else:
						var forward = getForward(tile)
						var success = push_tile(tile, forward.x, forward.y)
						if (!success):
							tile.direction = 2 if (tile.direction == 0) else 0 if (tile.direction == 2) else 1 if (tile.direction == 3) else 3
							tile.updateSpriteAnim()
							forward = getForward(tile)
							push_tile(tile, forward.x, forward.y)
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "shift")):
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
			if (ifPropertyUsed(tile.tileName, "is", "fall")):
				yeet_tile(tile, 0, 1)
	# todo (NOUN IS NOT NOUN) or (NOUN IS EMPTY)
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "done")):
				destroyTile(tile, true)
				continue
	# todo eat
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "weak")):
				for subtile in tiles:
					if (subtile != tile && subtile.pos == tile.pos):
						destroyTile(tile)
						break
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "sink")):
				for subtile in tiles:
					if (subtile != tile && subtile.pos == tile.pos):
						destroyTile(subtile)
						destroyTile(tile)
						break
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "hot")):
				for subtile in tiles:
					if (subtile.pos == tile.pos && ifRuleActive(subtile.tileName, "is", "melt")):
						destroyTile(subtile)
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "defeat")):
				for subtile in tiles:
					if (subtile.pos == tile.pos && ifRuleActive(subtile.tileName, "is", "you")):
						destroyTile(subtile)
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "shut")):
				for subtile in tiles:
					if (ifRuleActive(subtile.tileName, "is", "open")):
						destroyTile(subtile)
						destroyTile(tile)
						break
	# unspecified order
	for tile in tiles:
		if (justSpawned.has(tile)):
			continue
		if (ifOperatorUsed(tile.tileName, "is")):
			if (ifPropertyUsed(tile.tileName, "is", "tele")):
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
			if (ifPropertyUsed(tile.tileName, "is", "win") || ifPropertyUsed(tile.tileName, "is", "end")):
				for subtile in tiles:
					if (subtile.pos == tile.pos && ifRuleActive(subtile.tileName, "is", "you")):
						controlsActive = false
			if (ifPropertyUsed(tile.tileName, "is", "bonus")):
				for subtile in tiles:
					if (subtile.pos == tile.pos && ifRuleActive(subtile.tileName, "is", "you")):
						destroyTile(tile)
						break
			if (ifPropertyUsed(tile.tileName, "is", "more")):
				var upFree = tile.pos.y > 0
				var downFree = tile.pos.y < worldHeight - 1
				var leftFree = tile.pos.x > 0
				var rightFree = tile.pos.x < worldWidth - 1
				var counter = 0
				for subtile in tiles:
					if (subtile.tileId == tile.tileId || is_tile_solid(subtile)):
						if (upFree && subtile.pos == tile.pos + Vector2.UP):
							upFree = false
							counter += 1
							if (counter >= 4):
								break
						elif (downFree && subtile.pos == tile.pos + Vector2.DOWN):
							downFree = false
							counter += 1
							if (counter >= 4):
								break
						elif (leftFree && subtile.pos == tile.pos + Vector2.LEFT):
							leftFree = false
							counter += 1
							if (counter >= 4):
								break
						elif (rightFree && subtile.pos == tile.pos + Vector2.RIGHT):
							rightFree = false
							counter += 1
							if (counter >= 4):
								break
				if (upFree):
					justSpawned.append(spawnTile(tile.pos.x, tile.pos.y - 1, tile.direction, tile.tileId))
				if (downFree):
					justSpawned.append(spawnTile(tile.pos.x, tile.pos.y + 1, tile.direction, tile.tileId))
				if (leftFree):
					justSpawned.append(spawnTile(tile.pos.x - 1, tile.pos.y, tile.direction, tile.tileId))
				if (rightFree):
					justSpawned.append(spawnTile(tile.pos.x + 1, tile.pos.y, tile.direction, tile.tileId))
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

# todo add open/shut here
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
	if (tile.tileType != 0):
		unappliedRules = true
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
	var worldRulesOld = worldRules
	worldRules = {}
	for tile in tiles:
		if (tile.tileType != 0):
			changeTileType(tile, tile.tileId)
	for tile in tiles:
		if (tile.tileType == 1 || ifRuleActiveRetro(tile.tileName, "is", "word", worldRulesOld)):
			checkTileRules(tile)
	for tile in tiles:
		if (ifOperatorUsed(tile.tileName, "is")):
			tile.isFloating = ifPropertyUsed(tile.tileName, "is", "float")
			tile.isSleeping = ifPropertyUsed(tile.tileName, "is", "sleep")
			tile.visible = !ifPropertyUsed(tile.tileName, "is", "hide")

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
	var affectedTile = tile1.tileName.split("_")[1] if "text_" in tile1.tileName else tile1.tileName
	var operator = tile2.tileName.split("_")[1]
	var action = tile3.tileName.split("_")[1]
	var ifReplacement = tile3.tileType == 1
	if (operator == "is"):
		if (ifReplacement):
			if (affectedTile != action):
				if (ifRuleActive(affectedTile, "is", affectedTile)):
					return
				if (affectedTile == "text"):
					for subTile in tiles:
						if (subTile.tileType != 0):
							if action == "text":
								changeTileType(subTile, findTileId("text_" + affectedTile))
							else:
								changeTileType(subTile, findTileId(action))
							subTile.updateSpriteAnim()
					unappliedRules = true
					worldRules = {}
				else:
					for subTile in tiles:
						if (subTile.tileName == affectedTile):
							if action == "text":
								changeTileType(subTile, findTileId("text_" + affectedTile))
								unappliedRules = true
							else:
								changeTileType(subTile, findTileId(action))
							subTile.updateSpriteAnim()
		elif (action == "win" && ifRuleActive(affectedTile, "is", "you") || action == "you" && ifRuleActive(affectedTile, "is", "win")):
			controlsActive = false
		elif (action == "defeat" && ifRuleActive(affectedTile, "is", "you") || action == "you" && ifRuleActive(affectedTile, "is", "defeat")):
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					destroyTile(subTile)
		elif (action == "hot" && ifRuleActive(affectedTile, "is", "melt") || action == "melt" && ifRuleActive(affectedTile, "is", "hot")):
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					destroyTile(subTile)
		elif (action == "shut" && ifRuleActive(affectedTile, "is", "open") || action == "open" && ifRuleActive(affectedTile, "is", "shut")):
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					destroyTile(subTile)
		elif (action == "up"):
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					subTile.direction = 1
					subTile.updateSpriteAnim()
		elif (action == "down"):
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					subTile.direction = 3
					subTile.updateSpriteAnim()
		elif (action == "left"):
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					subTile.direction = 2
					subTile.updateSpriteAnim()
		elif (action == "right"):
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					subTile.direction = 0
					subTile.updateSpriteAnim()
		elif (action == "done"):
			for subTile in tiles:
				if (subTile.tileName == affectedTile):
					destroyTile(subTile)
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

func ifRuleActiveRetro(tile_name, operator, action, worldRules) -> bool:
	return (worldRules.has(tile_name) || worldRules.has(tile_name + "2") || worldRules.has(tile_name + "3")) && worldRules[tile_name].has(operator) && worldRules[tile_name][operator].has(action)

func ifOperatorUsed(tile_name, operator) -> String:
	if (worldRules.has(tile_name) && worldRules[tile_name].has(operator)):
		return worldRules[tile_name][operator][worldRules[tile_name][operator].keys()[0]]
	return ""

func ifPropertyUsed(tile_name, operator, action) -> bool:
	return worldRules[tile_name][operator].has(action)