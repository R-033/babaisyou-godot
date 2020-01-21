extends Node

# todo float
# fix more
# todo red
# todo blue
# todo turn
# todo deturn
# todo still
# todo level
# todo empty
# todo bonus

var loaded

var tiles = []
var worldRulesStatic = {}
var worldRulesDynamic = []

var rulesStatic = {}

var worldWidth = 10
var worldHeight = 10

var worldLerpTime = 1
var worldAnimationFrame = 0

var animtimer = 0

var unappliedMovement = null
var unappliedRules = false
var unappliedAutoTile = false

onready var tilePrefab = preload("res://src/tile.tscn")

var database
var loadedSprites = {}
var palette

var controlsActive = true

var startTime = OS.get_ticks_msec()
var curTime = startTime

func test_pong() -> void:
	worldWidth = 27
	worldHeight = 23
	
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
	
	for y in range(19, 23):
		for x in range(1, 4):
			spawnTileByName(x, y, 0, "tile")
	
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
	
	spawnTileByName(worldWidth - 2, 11, 1, "keke")
	spawnTileByName(worldWidth - 2, 12, 1, "keke")
	spawnTileByName(worldWidth - 2, 13, 1, "keke")
	spawnTileByName(worldWidth - 2, 14, 1, "keke")
	spawnTileByName(worldWidth - 2, 15, 1, "keke")
	
	spawnTileByName(14, 10, 0, "orb")

func test_syntax() -> void:
	worldWidth = 21
	worldHeight = 15
	
	spawnTileByName(0, 0, 0, "text_baba")
	spawnTileByName(1, 0, 0, "text_is")
	spawnTileByName(2, 0, 0, "text_you")
	
	spawnTileByName(3, 0, 0, "baba")
	
	for y in range(0, worldHeight):
		for x in range(0, worldWidth):
			spawnTileByName(x, y, 0, "tile")

func test_paint() -> void:
	worldWidth = 12
	worldHeight = 12
	
	spawnTileByName(0, 0, 0, "text_love")
	spawnTileByName(1, 0, 0, "text_make")
	spawnTileByName(2, 0, 0, "text_line")
	spawnTileByName(3, 0, 0, "wall")
	spawnTileByName(4, 0, 0, "text_love")
	spawnTileByName(5, 0, 0, "text_is")
	spawnTileByName(6, 0, 0, "text_push")
	spawnTileByName(0, 1, 0, "wall")
	spawnTileByName(1, 1, 0, "wall")
	spawnTileByName(2, 1, 0, "wall")
	spawnTileByName(3, 1, 0, "wall")
	spawnTileByName(0, 2, 0, "text_baba")
	spawnTileByName(1, 2, 0, "text_is")
	spawnTileByName(2, 2, 0, "text_you")
	spawnTileByName(3, 2, 0, "wall")
	spawnTileByName(0, 3, 0, "wall")
	spawnTileByName(1, 3, 0, "wall")
	spawnTileByName(2, 3, 0, "wall")
	spawnTileByName(3, 3, 0, "wall")
	spawnTileByName(0, 4, 0, "text_wall")
	spawnTileByName(1, 4, 0, "text_is")
	spawnTileByName(2, 4, 0, "text_stop")
	spawnTileByName(3, 4, 0, "wall")
	spawnTileByName(0, 5, 0, "wall")
	spawnTileByName(1, 5, 0, "wall")
	spawnTileByName(2, 5, 0, "wall")
	spawnTileByName(3, 5, 0, "wall")
	spawnTileByName(0, 6, 0, "text_keke")
	spawnTileByName(1, 6, 0, "text_eat")
	spawnTileByName(2, 6, 0, "text_line")
	spawnTileByName(3, 6, 0, "wall")
	spawnTileByName(0, 7, 0, "wall")
	spawnTileByName(1, 7, 0, "wall")
	spawnTileByName(2, 7, 0, "wall")
	spawnTileByName(3, 7, 0, "wall")
	spawnTileByName(0, 8, 0, "text_keke")
	spawnTileByName(1, 8, 0, "text_is")
	spawnTileByName(2, 8, 0, "text_push")
	spawnTileByName(3, 8, 0, "wall")
	spawnTileByName(0, 9, 0, "wall")
	spawnTileByName(1, 9, 0, "wall")
	spawnTileByName(2, 9, 0, "wall")
	spawnTileByName(3, 9, 0, "wall")
	
	spawnTileByName(6, 2, 0, "baba")
	spawnTileByName(6, 3, 0, "keke")
	spawnTileByName(6, 4, 0, "love")

func _ready():
	
	database = load("res://src/database.gd").tiles
	
	#loadLevel(0)
	
	loadPalette("default.png")
	
	test_pong()
	
	#test_syntax()
	
	#test_paint()
	
	var cam = get_node("/root/root/Camera2D")
	cam.position = Vector2(round(float(worldWidth * 24) / 2.0), round(float(worldHeight * 24) / 2.0))
	var display_size = OS.get_screen_size()
	var zoom = clamp(max(worldWidth, worldHeight) / (min(display_size.x, display_size.y) / 22), 0.5, 1)
	cam.zoom = Vector2.ONE * zoom
	OS.set_window_size(Vector2(worldWidth * 24 * (1 / zoom), worldHeight * 24 * (1 / zoom)))
	
	if (unappliedRules):
		unappliedRules = false
		checkTheRules()
	
	if (unappliedAutoTile):
		unappliedAutoTile = false
		updateAutoTile()

func updateAutoTile() -> void:
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

var palettes = ["default.png", "abstract.png", "autumn.png", "contrast.png", "factory.png", "garden.png", "marshmallow.png", "mono.png", "mountain.png", "ocean.png", "ruins.png", "space.png", "swamp.png", "test.png", "variant.png", "volcano.png"]
var curpal = 0

func _input(ev):
	if (worldLerpTime < 1 || !controlsActive):
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
		if (unappliedAutoTile):
			unappliedAutoTile = false
			updateAutoTile()

func spawnTileByName(x, y, direction, tileName) -> Node:
	return spawnTile(x, y, direction, findTileId(tileName))

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
	
	tile.isFloating = ifRuleActive(tile.tileName, "is", "float", tile)
	tile.isSleeping = ifRuleActive(tile.tileName, "is", "sleep", tile)
	tile.visible = !ifRuleActive(tile.tileName, "is", "hide", tile)
	
	var rawType = database[name]["type"]
	if (rawType == 0):
		if (database[name]["unittype"] == "text"):
			rawType = 1 # text_baba
		# baba
	elif (rawType == 1): # text_is
		rawType = 2
	elif (rawType == 2): # text_you
		rawType = 3
	elif (rawType == 4): # text_not
		rawType = 4
	elif (rawType == 6): # text_and
		rawType = 5
	elif (rawType == 7): # text_near
		rawType = 6
	elif (rawType == 3): # text_lonely
		rawType = 7
	else:
		push_error("unknown tile type " + str(rawType) + " (" + tile.tileName + ")")
	
	if (tile.tileType != 0):
		unappliedRules = true
	
	tile.tileType = rawType
	
	if (tile.tileType != 0):
		unappliedRules = true
	
	tile.tilingMode = database[name]["tiling"]
	
	if (tile.tilingMode != 1):
		tile.autoTileValue = 0
	else:
		unappliedAutoTile = true
	
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

func destroyTile(tile, forced = false) -> bool:
	if (!forced && ifRuleActive(tile.tileName, "is", "safe", tile)):
		return false
	var hasReplacement = ifOperatorUsed(tile.tileName, "has", tile)
	if (hasReplacement != ""):
		changeTileType(tile, findTileId(hasReplacement))
		return false
	if (tile.tileType != 0):
		unappliedRules = true
	if (tile.tilingMode == 1):
		unappliedAutoTile = true
	tiles.erase(tile)
	remove_child(tile)
	return true

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

func tileSorter(a, b):
	return a.pos.y * worldWidth + a.pos.x < b.pos.y * worldWidth + b.pos.x

func moveDirFix(tile, forward, rulesStatic, rulesDynamic) -> void:
	for subTile in tiles:
		if (ifRuleActive_cached(subTile.tileName, "is", "move", rulesStatic[subTile.tileName], rulesDynamic[subTile]) && !subTile.isSleeping):
			if (subTile.pos == tile.pos + forward):
				subTile.direction = tile.direction
				subTile.updateSpriteAnim()
				moveDirFix(subTile, forward, rulesStatic, rulesDynamic)

func updateWorld() -> void:
	var justTeleported = []
	var justShifted = []
	var justSpawned = []
	var rulesDynamic = {}
	tiles.sort_custom(self, "tileSorter")
	var tilesTrimmed = []
	for tile in tiles:
		if (tile.tilingMode == 3):
			tile.updateWalkFrame()
			tile.updateSpriteAnim()
		rulesDynamic[tile] = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, tile)
		if (rulesStatic[tile.tileName].size() > 0 || rulesDynamic[tile].size() > 0):
			tilesTrimmed.append(tile)
			tile.isFloating = ifRuleActive_cached(tile.tileName, "is", "float", rulesStatic[tile.tileName], rulesDynamic[tile])
			tile.isSleeping = ifRuleActive_cached(tile.tileName, "is", "sleep", rulesStatic[tile.tileName], rulesDynamic[tile])
			tile.visible = !ifRuleActive_cached(tile.tileName, "is", "hide", rulesStatic[tile.tileName], rulesDynamic[tile])
		else:
			tile.isFloating = false
			tile.isSleeping = false
			tile.visible = true
	var rs
	var rd
	for tile in tilesTrimmed:
		rs = rulesStatic[tile.tileName]
		rd = rulesDynamic[tile]
		if (unappliedMovement != null && ifRuleActive_cached(tile.tileName, "is", "you", rs, rd) && !tile.isSleeping && unappliedMovement != Vector2.ZERO):
			if (ifRuleActive_cached(tile.tileName, "is", "up", rs, rd)):
				push_tile(tile, 0, -1, rulesStatic, rulesDynamic, true, "you")
			elif (ifRuleActive_cached(tile.tileName, "is", "down", rs, rd)):
				push_tile(tile, 0, 1, rulesStatic, rulesDynamic, true, "you")
			elif (ifRuleActive_cached(tile.tileName, "is", "left", rs, rd)):
				push_tile(tile, -1, 0, rulesStatic, rulesDynamic, true, "you")
			elif (ifRuleActive_cached(tile.tileName, "is", "right", rs, rd)):
				push_tile(tile, 1, 0, rulesStatic, rulesDynamic, true, "you")
			else:
				push_tile(tile, unappliedMovement.x, unappliedMovement.y, rulesStatic, rulesDynamic, true, "you")
	if (unappliedRules):
		unappliedRules = false
		checkTheRules()
	tilesTrimmed = []
	for tile in tiles:
		rulesDynamic[tile] = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, tile)
		if (rulesStatic[tile.tileName].size() > 0 || rulesDynamic[tile].size() > 0):
			tilesTrimmed.append(tile)
	for tile in tilesTrimmed:
		rs = rulesStatic[tile.tileName]
		rd = rulesDynamic[tile]
		if (ifRuleActive_cached(tile.tileName, "is", "move", rs, rd) && !tile.isSleeping):
			for i in range(0, getRuleStackValue_cached(tile.tileName, "is", "move", rs, rd)):
				if (ifRuleActive_cached(tile.tileName, "is", "up", rs, rd)):
					push_tile(tile, 0, -1, rulesStatic, rulesDynamic, true)
				elif (ifRuleActive_cached(tile.tileName, "is", "down", rs, rd)):
					push_tile(tile, 0, 1, rulesStatic, rulesDynamic, true)
				elif (ifRuleActive_cached(tile.tileName, "is", "left", rs, rd)):
					push_tile(tile, -1, 0, rulesStatic, rulesDynamic, true)
				elif (ifRuleActive_cached(tile.tileName, "is", "right", rs, rd)):
					push_tile(tile, 1, 0, rulesStatic, rulesDynamic, true)
				else:
					var forward = getForward(tile)
					var success = push_tile(tile, forward.x, forward.y, rulesStatic, rulesDynamic, true)
					if (!success):
						tile.direction = 2 if (tile.direction == 0) else 0 if (tile.direction == 2) else 1 if (tile.direction == 3) else 3
						tile.updateSpriteAnim()
						forward = getForward(tile)
						moveDirFix(tile, forward, rulesStatic, rulesDynamic)
						push_tile(tile, forward.x, forward.y, rulesStatic, rulesDynamic, true)
	if (unappliedRules):
		unappliedRules = false
		checkTheRules()
	tilesTrimmed = []
	for tile in tiles:
		rulesDynamic[tile] = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, tile)
		if (rulesStatic[tile.tileName].size() > 0 || rulesDynamic[tile].size() > 0):
			tilesTrimmed.append(tile)
		else:
			continue
		rs = rulesStatic[tile.tileName]
		rd = rulesDynamic[tile]
		if (ifRuleActive_cached(tile.tileName, "is", "shift", rs, rd)):
			var needsToBePushed = []
			var forward = getForward(tile)
			for subtile in tiles:
				if (subtile == tile):
					continue
				if (!justShifted.has(subtile) && subtile.pos == tile.pos):
					needsToBePushed.append(subtile)
			for subtile in needsToBePushed:
				if (push_tile(subtile, forward.x, forward.y, rulesStatic, rulesDynamic)):
					justShifted.append(subtile)
		if (ifRuleActive_cached(tile.tileName, "is", "tele", rs, rd)):
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
				postMovementUpdate(subtile, rulesStatic, rulesDynamic)
				justTeleported.append(subtile)
		if (ifRuleActive_cached(tile.tileName, "is", "fall", rs, rd)):
			yeet_tile(tile, 0, 1, rulesStatic, rulesDynamic)
	# todo (NOUN IS NOT NOUN) or (NOUN IS EMPTY)
	for tileNum in range(0, tilesTrimmed.size()):
		if (tileNum > tilesTrimmed.size() - 1):
			break
		rs = rulesStatic[tilesTrimmed[tileNum].tileName]
		rd = rulesDynamic[tilesTrimmed[tileNum]]
		if (ifRuleActive_cached(tilesTrimmed[tileNum].tileName, "is", "done", rs, rd)):
			if (destroyTile(tilesTrimmed[tileNum], true)):
				tileNum -= 1
			continue
	for tileNum in range(0, tilesTrimmed.size()):
		if (tileNum > tilesTrimmed.size() - 1):
			break
		rs = rulesStatic[tilesTrimmed[tileNum].tileName]
		rd = rulesDynamic[tilesTrimmed[tileNum]]
		if (ifRuleActive_cached(tilesTrimmed[tileNum].tileName, "is", "sink", rs, rd)):
			for subTileNum in range(0, tiles.size()):
				if (subTileNum > tiles.size() - 1):
					break
				if (tiles[subTileNum] != tilesTrimmed[tileNum] && tiles[subTileNum].pos == tilesTrimmed[tileNum].pos):
					if (destroyTile(tiles[subTileNum])):
						subTileNum -= 1
					if (destroyTile(tilesTrimmed[tileNum])):
						tileNum -= 1
					break
	for tileNum in range(0, tilesTrimmed.size()):
		if (tileNum > tilesTrimmed.size() - 1):
			break
		rs = rulesStatic[tilesTrimmed[tileNum].tileName]
		rd = rulesDynamic[tilesTrimmed[tileNum]]
		if (ifRuleActive_cached(tilesTrimmed[tileNum].tileName, "is", "hot", rs, rd)):
			for subTileNum in range(0, tiles.size()):
				if (subTileNum > tiles.size() - 1):
					break
				if (tiles[subTileNum].pos == tilesTrimmed[tileNum].pos && ifRuleActive_cached(tiles[subTileNum].tileName, "is", "melt", rulesStatic[tiles[subTileNum].tileName], rulesDynamic[tiles[subTileNum]])):
					if (destroyTile(tiles[subTileNum])):
						subTileNum -= 1
	for tileNum in range(0, tilesTrimmed.size()):
		if (tileNum > tilesTrimmed.size() - 1):
			break
		rs = rulesStatic[tilesTrimmed[tileNum].tileName]
		rd = rulesDynamic[tilesTrimmed[tileNum]]
		if (ifRuleActive_cached(tilesTrimmed[tileNum].tileName, "is", "defeat", rs, rd)):
			for subTileNum in range(0, tiles.size()):
				if (subTileNum > tiles.size() - 1):
					break
				if (tiles[subTileNum].pos == tilesTrimmed[tileNum].pos && ifRuleActive_cached(tiles[subTileNum].tileName, "is", "you", rulesStatic[tiles[subTileNum].tileName], rulesDynamic[tiles[subTileNum]])):
					if (destroyTile(tiles[subTileNum])):
						subTileNum -= 1
	for tileNum in range(0, tilesTrimmed.size()):
		if (tileNum > tilesTrimmed.size() - 1):
			break
		rs = rulesStatic[tilesTrimmed[tileNum].tileName]
		rd = rulesDynamic[tilesTrimmed[tileNum]]
		if (ifRuleActive_cached(tilesTrimmed[tileNum].tileName, "is", "shut", rs, rd)):
			for subTileNum in range(0, tiles.size()):
				if (subTileNum > tiles.size() - 1):
					break
				if (ifRuleActive_cached(tiles[subTileNum].tileName, "is", "open", rs, rd)):
					if (destroyTile(tiles[subTileNum])):
						subTileNum -= 1
					if (destroyTile(tilesTrimmed[tileNum])):
						tileNum -= 1
					break
	# unspecified order
	for tileNum in range(0, tilesTrimmed.size()):
		if (tileNum > tilesTrimmed.size() - 1):
			break
		if (justSpawned.has(tilesTrimmed[tileNum])):
			continue
		rs = rulesStatic[tilesTrimmed[tileNum].tileName]
		rd = rulesDynamic[tilesTrimmed[tileNum]]
		if (ifRuleActive_cached(tilesTrimmed[tileNum].tileName, "is", "win", rs, rd) || ifRuleActive_cached(tilesTrimmed[tileNum].tileName, "is", "end", rs, rd)):
			for subtile in tiles:
				if (subtile.pos == tilesTrimmed[tileNum].pos && ifRuleActive_cached(subtile.tileName, "is", "you", rulesStatic[subtile.tileName], rulesDynamic[subtile])):
					controlsActive = false
		if (ifRuleActive_cached(tilesTrimmed[tileNum].tileName, "is", "more", rs, rd)):
			var upFree = tilesTrimmed[tileNum].pos.y > 0
			var downFree = tilesTrimmed[tileNum].pos.y < worldHeight - 1
			var leftFree = tilesTrimmed[tileNum].pos.x > 0
			var rightFree = tilesTrimmed[tileNum].pos.x < worldWidth - 1
			var counter = 0
			for subtile in tiles:
				if (subtile.tileId == tilesTrimmed[tileNum].tileId || is_tile_solid(subtile, rs, rd)):
					if (upFree && subtile.pos == tilesTrimmed[tileNum].pos + Vector2.UP):
						upFree = false
						counter += 1
						if (counter >= 4):
							break
					elif (downFree && subtile.pos == tilesTrimmed[tileNum].pos + Vector2.DOWN):
						downFree = false
						counter += 1
						if (counter >= 4):
							break
					elif (leftFree && subtile.pos == tilesTrimmed[tileNum].pos + Vector2.LEFT):
						leftFree = false
						counter += 1
						if (counter >= 4):
							break
					elif (rightFree && subtile.pos == tilesTrimmed[tileNum].pos + Vector2.RIGHT):
						rightFree = false
						counter += 1
						if (counter >= 4):
							break
			if (upFree):
				justSpawned.append(spawnTile(tilesTrimmed[tileNum].pos.x, tilesTrimmed[tileNum].pos.y - 1, tilesTrimmed[tileNum].direction, tilesTrimmed[tileNum].tileId))
			if (downFree):
				justSpawned.append(spawnTile(tilesTrimmed[tileNum].pos.x, tilesTrimmed[tileNum].pos.y + 1, tilesTrimmed[tileNum].direction, tilesTrimmed[tileNum].tileId))
			if (leftFree):
				justSpawned.append(spawnTile(tilesTrimmed[tileNum].pos.x - 1, tilesTrimmed[tileNum].pos.y, tilesTrimmed[tileNum].direction, tilesTrimmed[tileNum].tileId))
			if (rightFree):
				justSpawned.append(spawnTile(tilesTrimmed[tileNum].pos.x + 1, tilesTrimmed[tileNum].pos.y, tilesTrimmed[tileNum].direction, tilesTrimmed[tileNum].tileId))
	unappliedMovement = null
	if (unappliedRules):
		unappliedRules = false
		checkTheRules()

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

func yeet_tile(tile, delta_x, delta_y, rulesStatic, rulesDynamic) -> void:
	while (true):
		if (!push_tile(tile, delta_x, delta_y, rulesStatic, rulesDynamic)):
			return;

# todo add open/shut here
func push_tile(tile, delta_x, delta_y, rulesStatic, rulesDynamic, moveMode = false, moveModeRule = "move") -> bool:
	if (ifRuleActive_cached(tile.tileName, "is", "fall", rulesStatic[tile.tileName], rulesDynamic[tile]) && delta_y < 0):
		return false
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	var oppositeX = tile.pos.x - delta_x
	var oppositeY = tile.pos.y - delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	var swapMode = ifRuleActive_cached(tile.tileName, "is", "swap", rulesStatic[tile.tileName], rulesDynamic[tile])
	var weakMode = ifRuleActive_cached(tile.tileName, "is", "weak", rulesStatic[tile.tileName], rulesDynamic[tile])
	var pushableTiles = []
	var pullableTiles = []
	for pushedTile in tiles:
		if (pushedTile.pos.x == newX && pushedTile.pos.y == newY):
			if (is_tile_solid(pushedTile, rulesStatic, rulesDynamic)):
				if (!weakMode || swapMode):
					if (swapMode || ifRuleActive_cached(pushedTile.tileName, "is", "swap", rulesStatic[pushedTile.tileName], rulesDynamic[pushedTile])):
						if (!can_be_pushed(pushedTile, -delta_x, -delta_y, tile, rulesStatic, rulesDynamic, moveMode, moveModeRule)):
							return false
					else:
						if (!can_be_pushed(pushedTile, delta_x, delta_y, tile, rulesStatic, rulesDynamic, moveMode, moveModeRule)):
							return false
				pushableTiles.append(pushedTile)
				if (swapMode):
					break
		elif (pushedTile.pos.x == oppositeX && pushedTile.pos.y == oppositeY):
			if (is_tile_solid(pushedTile, rulesStatic, rulesDynamic)):
				if (!can_be_pulled(pushedTile, delta_x, delta_y, rulesStatic, rulesDynamic)):
					continue
				pullableTiles.append(pushedTile)
	for pulledTile in pullableTiles:
		pull_tile(pulledTile, delta_x, delta_y, rulesStatic, rulesDynamic)
	if (weakMode && !swapMode && pushableTiles.size() > 0):
		if (destroyTile(tile)):
			return true
	for pushedTile in pushableTiles:
		if (!moveMode || !ifRuleActive_cached(pushedTile.tileName, "is", moveModeRule, rulesStatic[pushedTile.tileName], rulesDynamic[pushedTile])):
			if (swapMode || ifRuleActive_cached(pushedTile.tileName, "is", "swap", rulesStatic[pushedTile.tileName], rulesDynamic[pushedTile])):
				pull_tile(pushedTile, -delta_x, -delta_y, rulesStatic, rulesDynamic)
			else:
				push_tile(pushedTile, delta_x, delta_y, rulesStatic, rulesDynamic, moveMode)
	tile.updatePos(newX, newY)
	if (tile.tileType != 0):
		unappliedRules = true
	if (tile.tilingMode == 1):
		unappliedAutoTile = true
	postMovementUpdate(tile, rulesStatic, rulesDynamic)
	return true

func postMovementUpdate(tile, rulesStatic, rulesDynamic) -> void:
	if (ifOperatorUsed_cached(tile.tileName, "make", rulesStatic[tile.tileName], rulesDynamic[tile])):
		for rule in rulesStatic[tile.tileName] + rulesDynamic[tile]:
			if (rule.has("make")):
				for tileName in rule["make"].keys():
					if "not " in tileName:
						push_error("making inversed tiles is not supported")
					else:
						var result = spawnTileByName(tile.oldPos.x, tile.oldPos.y, tile.direction, tileName)
						if (!rulesStatic.has(result.tileName)):
							rulesStatic[result.tileName] = getAppliableRulesStatic(result.tileName, worldRulesStatic, result)
						rulesDynamic[result] = getAppliableRulesDynamic(result.tileName, worldRulesDynamic, result)
	if (ifOperatorUsed_cached(tile.tileName, "eat", rulesStatic[tile.tileName], rulesDynamic[tile])):
		for rule in rulesStatic[tile.tileName] + rulesDynamic[tile]:
			if (rule.has("eat")):
				for subTileNum in range(0, tiles.size()):
					if (subTileNum > tiles.size() - 1):
						break
					if (tiles[subTileNum] != tile && tiles[subTileNum].pos == tile.pos):
						for tileName in rule["eat"].keys():
							if (tileName == "not all"):
								continue
							if "not " in tileName:
								var affectedTile = tileName.replace("not ", "")
								if (tiles[subTileNum].tileName != tileName):
									if (destroyTile(tiles[subTileNum])):
										subTileNum -= 1
									break
							elif (tiles[subTileNum].tileName == tileName || tileName == "all" || tileName == "level"):
								if (destroyTile(tiles[subTileNum])):
									subTileNum -= 1
								continue

func pull_tile(tile, delta_x, delta_y, rulesStatic, rulesDynamic) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	var oppositeX = tile.pos.x - delta_x
	var oppositeY = tile.pos.y - delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	var pullableTiles = []
	for pushedTile in tiles:
		if (pushedTile.pos.x == oppositeX && pushedTile.pos.y == oppositeY):
			if (is_tile_solid(pushedTile, rulesStatic, rulesDynamic)):
				if (!can_be_pulled(pushedTile, delta_x, delta_y, rulesStatic, rulesDynamic)):
					continue
				pullableTiles.append(pushedTile)
	for pulledTile in pullableTiles:
		pull_tile(pulledTile, delta_x, delta_y, rulesStatic, rulesDynamic)
	tile.updatePos(newX, newY)
	if (tile.tilingMode == 1):
		unappliedAutoTile = true
	if (tile.tileType != 0):
		unappliedRules = true
	if (tile.tilingMode == 1):
		unappliedAutoTile = true
	postMovementUpdate(tile, rulesStatic, rulesDynamic)
	return true

func can_be_pushed(tile, delta_x, delta_y, referenceTile, rulesStatic, rulesDynamic, moveMode = false, moveModeRule = "move") -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (!moveMode || !ifRuleActive_cached(tile.tileName, "is", moveModeRule, rulesStatic[tile.tileName], rulesDynamic[tile])):
		if (ifRuleActive_cached(tile.tileName, "is", "stop", rulesStatic[tile.tileName], rulesDynamic[tile])):
			return false
		if (tile.tileType == 0 && !ifRuleActive_cached(tile.tileName, "is", "push", rulesStatic[tile.tileName], rulesDynamic[tile])):
			return false
	var swapMode = ifRuleActive_cached(tile.tileName, "is", "swap", rulesStatic[tile.tileName], rulesDynamic[tile])
	for pushedTile in tiles:
		if (pushedTile.pos.x == newX && pushedTile.pos.y == newY):
			if (is_tile_solid(pushedTile, rulesStatic, rulesDynamic)):
				if (!swapMode):
					if (!can_be_pushed(pushedTile, delta_x, delta_y, tile, rulesStatic, rulesDynamic, moveMode, moveModeRule)):
						return false
	return true

func can_be_pulled(tile, delta_x, delta_y, rulesStatic, rulesDynamic) -> bool:
	var newX = tile.pos.x + delta_x
	var newY = tile.pos.y + delta_y
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (ifRuleActive_cached(tile.tileName, "is", "stop", rulesStatic[tile.tileName], rulesDynamic[tile])):
		return false
	if (!ifRuleActive_cached(tile.tileName, "is", "pull", rulesStatic[tile.tileName], rulesDynamic[tile])):
		return false
	return true

func is_tile_solid(tile, rulesStatic, rulesDynamic) -> bool:
	if (tile.tileType != 0):
		return true
	if (ifRuleActive_cached(tile.tileName, "is", "push", rulesStatic[tile.tileName], rulesDynamic[tile])):
		return true
	if (ifRuleActive_cached(tile.tileName, "is", "pull", rulesStatic[tile.tileName], rulesDynamic[tile])):
		return true
	if (ifRuleActive_cached(tile.tileName, "is", "stop", rulesStatic[tile.tileName], rulesDynamic[tile])):
		return true
	return false

func checkTheRules() -> void:
	var worldRulesOld = worldRulesStatic
	var worldRulesDynOld = worldRulesDynamic
	worldRulesStatic = {}
	worldRulesDynamic = []
	var usedHorizontally = []
	var usedVertically = []
	for tile in tiles:
		if (tile.tileType != 0):
			changeTileType(tile, tile.tileId)
	for tile in tiles:
		if (!usedVertically.has(tile)):
			checkTileRules(tile, worldRulesOld, worldRulesDynOld, true, usedVertically)
		if (!usedHorizontally.has(tile)):
			checkTileRules(tile, worldRulesOld, worldRulesDynOld, false, usedHorizontally)
	rulesStatic = {}
	for tile in tiles:
		if (!rulesStatic.has(tile.tileName)):
			rulesStatic[tile.tileName] = getAppliableRulesStatic(tile.tileName, worldRulesStatic, tile)
		var rulesCacheDynamic = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, tile)
		if (ifOperatorUsed_cached(tile.tileName, "is", rulesStatic[tile.tileName], rulesCacheDynamic)):
			tile.isFloating = ifRuleActive_cached(tile.tileName, "is", "float", rulesStatic[tile.tileName], rulesCacheDynamic)
			tile.isSleeping = ifRuleActive_cached(tile.tileName, "is", "sleep", rulesStatic[tile.tileName], rulesCacheDynamic)
			tile.visible = !ifRuleActive_cached(tile.tileName, "is", "hide", rulesStatic[tile.tileName], rulesCacheDynamic)

#finalRule = [
#	[
#		lonely not baba,
#		not lonely keke,
#		near,
#		not wall
#	],
#	is not you
#	is move
#]

#	text_is
#		rawType = 2
#	text_you
#		rawType = 3
#	text_not
#		rawType = 4
#	text_and
#		rawType = 5
#	text_near
#		rawType = 6
#	text_lonely
#		rawType = 7

func checkTileRules(tile, worldRulesOld, worldRulesDynOld, vertical, usedTilesGlobal) -> void:
	var finalRule = []
	var usedTiles = []
	
	# build nouns
	var usedAnd = null
	var oldEnd = null
	var endTile = null
	finalRule.append([])
	while true:
		endTile = grabNoun(tile, finalRule[0], worldRulesOld, worldRulesDynOld, vertical, true, usedTiles)
		if (endTile == null):
			break
		if (usedAnd != null):
			usedTiles.append(usedAnd)
		var andTile = null
		for _andTile in tiles:
			if (!vertical && _andTile.pos == endTile.pos + Vector2.RIGHT):
				if (_andTile.tileType == 5):
					andTile = _andTile
					break
			elif (vertical && _andTile.pos == endTile.pos + Vector2.DOWN):
				if (_andTile.tileType == 5):
					andTile = _andTile
					break
		if (andTile == null):
			break
		var newTile = null
		for nounTile in tiles:
			if (vertical && nounTile.pos == andTile.pos + Vector2.DOWN || !vertical && nounTile.pos == andTile.pos + Vector2.RIGHT):
				if (nounTile.tileType == 1 || nounTile.tileType == 4 || nounTile.tileType == 7 || nounTile.tileType == 0 && ifRuleActiveRetro(nounTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, nounTile)):
					newTile = nounTile
					usedAnd = andTile
					break
		if (newTile == null):
			break
		oldEnd = endTile
		tile = newTile
	if (finalRule[0].size() == 0):
		return
	if (endTile != null):
		tile = endTile
	elif (oldEnd != null):
		tile = oldEnd
	
	# look for operator
	var isTile = null
	for _isTile in tiles:
		if (!vertical && _isTile.pos == tile.pos + Vector2.RIGHT || vertical && _isTile.pos == tile.pos + Vector2.DOWN):
			if (_isTile.tileType == 2):
				isTile = _isTile
				usedTiles.append(isTile)
				break
	if (isTile == null):
		return
	var isTileName = isTile.tileName.split("_")[1]
	
	# look for properties
	tile = isTile
	var andTile
	while true:
		endTile = grabProperty(tile, finalRule, vertical, usedTiles, isTileName, worldRulesOld, worldRulesDynOld)
		if (endTile == null):
			break
		if (andTile != null):
			usedTiles.append(andTile)
		andTile = null
		for _andTile in tiles:
			if (!vertical && _andTile.pos == endTile.pos + Vector2.RIGHT):
				if (_andTile.tileType == 5):
					andTile = _andTile
					break
			elif (vertical && _andTile.pos == endTile.pos + Vector2.DOWN):
				if (_andTile.tileType == 5):
					andTile = _andTile
					break
		if (andTile == null):
			break
		tile = andTile
	if (finalRule.size() == 1):
		return
	
	# applying rule to game
	if (applyRule(finalRule)):
		for tile in usedTiles:
			changeTileType(tile, tile.tileId, true)
			usedTilesGlobal.append(tile)

func grabProperty(tile, container, vertical, usedTiles, isTileName, worldRulesOld, worldRulesDynOld) -> Node:
	for propTile in tiles:
		if (vertical && propTile.pos == tile.pos + Vector2.DOWN || !vertical && propTile.pos == tile.pos + Vector2.RIGHT):
			if (propTile.tileType == 3 || propTile.tileType == 1 || ifRuleActiveRetro(propTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, propTile)):
				# is you
				if (isTileName == ""):
					container.append(propTile.tileName.split("_")[1])
				else:
					container.append(isTileName + " " + propTile.tileName.split("_")[1])
				usedTiles.append(propTile)
				return propTile
			if (propTile.tileType == 4):
				for propTile2 in tiles:
					if (vertical && propTile2.pos == propTile.pos + Vector2.DOWN || !vertical && propTile2.pos == propTile.pos + Vector2.RIGHT):
						if (propTile2.tileType == 3 || propTile.tileType == 1 || ifRuleActiveRetro(propTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, propTile)):
							# is not you
							if (isTileName == ""):
								container.append("not " + propTile2.tileName.split("_")[1])
							else:
								container.append(isTileName + " not " + propTile2.tileName.split("_")[1])
							usedTiles.append(propTile)
							usedTiles.append(propTile2)
							return propTile2
				return null
	return null

func grabNoun(tile, container, worldRulesOld, worldRulesDynOld, vertical, conditionAllowed, usedTiles) -> Node:
	if (tile.tileType == 1 || tile.tileType == 4 || tile.tileType == 7 || tile.tileType == 0 && ifRuleActiveRetro(tile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, tile)):
		if (tile.tileType == 4):
			for subTile in tiles:
				if (vertical && subTile.pos == tile.pos + Vector2.DOWN || !vertical && subTile.pos == tile.pos + Vector2.RIGHT):
					if (subTile.tileType == 1 || ifRuleActiveRetro(subTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, subTile)):
						# not smh
						container.append("not " + subTile.tileName.split("_")[1] if subTile.tileType == 1 else subTile.tileName)
						usedTiles.append(tile)
						usedTiles.append(subTile)
						if (conditionAllowed):
							return grabCondition(subTile, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
						return subTile
					elif (subTile.tileType == 7):
						for subTile2 in tiles:
							if (vertical && subTile2.pos == subTile.pos + Vector2.DOWN || !vertical && subTile2.pos == subTile.pos + Vector2.RIGHT):
								if (subTile2.tileType == 1 || ifRuleActiveRetro(subTile2.tileName, "is", "word", worldRulesOld, worldRulesDynOld, subTile2)):
									# not lonely smh
									container.append("not lonely " + subTile2.tileName.split("_")[1] if subTile2.tileType == 1 else subTile2.tileName)
									usedTiles.append(tile)
									usedTiles.append(subTile)
									usedTiles.append(subTile2)
									if (conditionAllowed):
										return grabCondition(subTile2, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
									return subTile2
								if (subTile2.tileType == 4):
									# not lonely not smh
									# todo
									return null
			return null
		if (tile.tileType == 7):
			for subTile in tiles:
				if (vertical && subTile.pos == tile.pos + Vector2.DOWN || !vertical && subTile.pos == tile.pos + Vector2.RIGHT):
					if (subTile.tileType == 1 || ifRuleActiveRetro(subTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, subTile)):
						# lonely smh
						container.append("lonely " + subTile.tileName.split("_")[1] if subTile.tileType == 1 else subTile.tileName)
						usedTiles.append(tile)
						usedTiles.append(subTile)
						if (conditionAllowed):
							return grabCondition(subTile, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
						return subTile
					if (subTile.tileType == 4):
						# lonely not smh
						# todo
						return null
			return null
		# smh
		container.append(tile.tileName.split("_")[1] if tile.tileType == 1 else tile.tileName)
		usedTiles.append(tile)
		if (conditionAllowed):
			return grabCondition(tile, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
		return tile
	return null

func grabCondition(tile, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles) -> Node:
	for subTile in tiles:
		if (vertical && subTile.pos == tile.pos + Vector2.DOWN || !vertical && subTile.pos == tile.pos + Vector2.RIGHT):
			if (subTile.tileType == 6):
				if (subTile.tileName == "text_facing"):
					container.append(subTile.tileName.split("_")[1])
					var result = grabProperty(subTile, container, vertical, usedTiles, "", worldRulesOld, worldRulesDynOld)
					if (result == null):
						container.remove(container.size() - 1)
					else:
						usedTiles.append(subTile)
						return grabConditionCheckForAdditional(result, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
				for subTile2 in tiles:
					if (vertical && subTile2.pos == subTile.pos + Vector2.DOWN || !vertical && subTile2.pos == subTile.pos + Vector2.RIGHT):
						container.append(subTile.tileName.split("_")[1])
						var result = grabNoun(subTile2, container, worldRulesOld, worldRulesDynOld, vertical, false, usedTiles)
						if (result == null):
							container.remove(container.size() - 1)
							continue
						usedTiles.append(subTile)
						return grabConditionCheckForAdditional(result, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
			elif (subTile.tileType == 4):
				for subTile3 in tiles:
					if (vertical && subTile3.pos == subTile.pos + Vector2.DOWN || !vertical && subTile3.pos == subTile.pos + Vector2.RIGHT):
						if (subTile3.tileType == 6):
							if (subTile3.tileName == "text_facing"):
								container.append("not " + subTile3.tileName.split("_")[1])
								var result = grabProperty(subTile3, container, vertical, usedTiles, "", worldRulesOld, worldRulesDynOld)
								if (result == null):
									container.remove(container.size() - 1)
								else:
									usedTiles.append(subTile3)
									usedTiles.append(subTile)
									return grabConditionCheckForAdditional(result, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
							for subTile2 in tiles:
								if (vertical && subTile2.pos == subTile3.pos + Vector2.DOWN || !vertical && subTile2.pos == subTile3.pos + Vector2.RIGHT):
									container.append("not " + subTile3.tileName.split("_")[1])
									var result = grabNoun(subTile2, container, worldRulesOld, worldRulesDynOld, vertical, false, usedTiles)
									if (result == null):
										container.remove(container.size() - 1)
										continue
									usedTiles.append(subTile3)
									usedTiles.append(subTile)
									return grabConditionCheckForAdditional(result, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
	return tile

func grabConditionCheckForAdditional(tile, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles) -> Node:
	for andTile in tiles:
		if (vertical && andTile.pos == tile.pos + Vector2.DOWN || !vertical && andTile.pos == tile.pos + Vector2.RIGHT):
			if (andTile.tileType == 5):
				for subTile in tiles:
					if (vertical && subTile.pos == andTile.pos + Vector2.DOWN || !vertical && subTile.pos == andTile.pos + Vector2.RIGHT):
						if (subTile.tileType == 6):
							var result = grabCondition(andTile, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
							if (result != andTile):
								usedTiles.append(andTile)
								return result
						elif (subTile.tileType == 4):
							for subTile2 in tiles:
								if (vertical && subTile2.pos == subTile.pos + Vector2.DOWN || !vertical && subTile2.pos == subTile.pos + Vector2.RIGHT):
									if (subTile2.tileType == 6):
										var result = grabCondition(andTile, container, worldRulesOld, worldRulesDynOld, vertical, usedTiles)
										if (result != andTile):
											usedTiles.append(andTile)
											return result
	return tile

func applyRule(finalRule) -> bool:
	var affectedTiles = finalRule[0]
	var actions = []
	for i in range(1, finalRule.size()):
		actions.append(finalRule[i])
	
	var tileNum = 0
	while (tileNum < affectedTiles.size()):
		var ruleDynamic = false
		var condition = []
		var subpos = 0
		if (tileNum < affectedTiles.size() - 2):
			while (affectedTiles[tileNum + subpos + 1] == "on" || affectedTiles[tileNum + subpos +1] == "near" || affectedTiles[tileNum + subpos + 1] == "facing" || affectedTiles[tileNum + subpos + 1] == "not on" || affectedTiles[tileNum + subpos + 1] == "not near" || affectedTiles[tileNum + subpos + 1] == "not facing"):
				condition.append(affectedTiles[tileNum + subpos + 1])
				condition.append(affectedTiles[tileNum + subpos + 2])
				subpos += 2
				ruleDynamic = true
				if (tileNum + subpos >= affectedTiles.size() - 2):
					break
		
		if "lonely" in affectedTiles[tileNum]:
			ruleDynamic = true
		
		for actionNum in range(0, actions.size()):
			var action = actions[actionNum].split(" ", false)
			if (ruleDynamic):
				var newRule = [affectedTiles[tileNum]]
				for cond in condition:
					newRule.append(cond)
				newRule.append(action[0])
				newRule.append(actions[actionNum].replace(action[0] + " ", ""))
				worldRulesDynamic.append(newRule)
				# todo applyRuleInstantly
			else:
				if (!saveRuleStatic(affectedTiles[tileNum], action[0], actions[actionNum].replace(action[0] + " ", ""))):
					return false
		
		tileNum += condition.size() + 1
	
	return true

func saveRuleStatic(tile_name, operator, action) -> bool:
	
	if (!applyRuleInstantly(tile_name, operator, action)):
		return false
	
	if (!worldRulesStatic.has(tile_name)):
		worldRulesStatic[tile_name] = {}
	if (!worldRulesStatic[tile_name].has(operator)):
		worldRulesStatic[tile_name][operator] = {}
	if (!worldRulesStatic[tile_name][operator].has(action)):
		worldRulesStatic[tile_name][operator][action] = 1
	else:
		worldRulesStatic[tile_name][operator][action] += 1
	
	return true

func applyRuleInstantly(affectedTile, operator, action) -> bool:
	# todo not support here
	var ifReplacement = false
	var tid = findTileId("text_" + action)
	if (database.has(tid)):
		ifReplacement = database[tid].type == 0
	if (operator == "is"):
		if (ifReplacement):
			if (affectedTile != action):
				if (affectedTile == "text"):
					for subTile in tiles:
						if (ifRuleActive(affectedTile, "is", affectedTile, subTile)):
							continue
						if (subTile.tileType != 0):
							if action == "text":
								changeTileType(subTile, findTileId("text_" + affectedTile))
							else:
								changeTileType(subTile, findTileId(action))
							subTile.updateSpriteAnim()
					unappliedRules = true
					worldRulesStatic = {}
					worldRulesDynamic = []
				else:
					for subTile in tiles:
						if (subTile.tileName == affectedTile):
							if action == "text":
								changeTileType(subTile, findTileId("text_" + affectedTile))
							else:
								changeTileType(subTile, findTileId(action))
							subTile.updateSpriteAnim()
		else:
			# probably won't work as I want but ok
			for subTile in tiles:
				if (affectedTile == "all" || affectedTile == "level" || subTile.tileName == affectedTile):
					if (action == "win" && ifRuleActive(affectedTile, "is", "you", subTile) || action == "you" && ifRuleActive(affectedTile, "is", "win", subTile)):
						controlsActive = false
					elif (action == "defeat" && ifRuleActive(affectedTile, "is", "you", subTile) || action == "you" && ifRuleActive(affectedTile, "is", "defeat", subTile)):
						destroyTile(subTile)
					elif (action == "hot" && ifRuleActive(affectedTile, "is", "melt", subTile) || action == "melt" && ifRuleActive(affectedTile, "is", "hot", subTile)):
						destroyTile(subTile)
					elif (action == "shut" && ifRuleActive(affectedTile, "is", "open", subTile) || action == "open" && ifRuleActive(affectedTile, "is", "shut", subTile)):
						destroyTile(subTile)
					elif (action == "up"):
						subTile.direction = 1
						subTile.updateSpriteAnim()
					elif (action == "down"):
						subTile.direction = 3
						subTile.updateSpriteAnim()
					elif (action == "left"):
						subTile.direction = 2
						subTile.updateSpriteAnim()
					elif (action == "right"):
						subTile.direction = 0
						subTile.updateSpriteAnim()
					elif (action == "done"):
						destroyTile(subTile)
	return true

func ifRuleActive(tile_name, operator, action, tile) -> bool:
	return ifRuleActiveRetro(tile_name, operator, action, worldRulesStatic, worldRulesDynamic, tile)

func ifRuleActiveRetro(tile_name, operator, action, worldRules, worldRulesDyn, tile) -> bool:
	return ifRuleActiveRetro_cached(tile_name, operator, action, worldRules, worldRulesDyn, getAppliableRulesStatic(tile_name, worldRules, tile), getAppliableRulesDynamic(tile_name, worldRulesDyn, tile))

# worldRulesDynamic have:
# - on
# - near
# - facing
# - lonely

# ["lonely not baba", "near", "not lonely wall", "is", "you"]

func getAppliableRulesStatic(tile_name, worldRules, tile) -> Array:
	var appliableRules = []
	
	if ("text_" in tile_name):
		tile_name = "text"
	
	for ruleNoun in worldRules.keys():
		if "not " in ruleNoun:
			var notWhat = ruleNoun.replace("not " , "")
			if (notWhat != tile_name && notWhat != "all"):
				appliableRules.append(worldRules[ruleNoun])
		else:
			if (ruleNoun == tile_name || ruleNoun == "all" || ruleNoun == "level"):
				appliableRules.append(worldRules[ruleNoun])
	
	return appliableRules

func getAppliableRulesDynamic(tile_name, worldRulesDyn, tile) -> Array:
	var appliableRules = []
	
	if ("text_" in tile_name):
		tile_name = "text"
	
	for rule in worldRulesDyn:
		var affectedTile;
		var lonelyType = -1
		if "not lonely " in rule[0]:
			affectedTile = rule[0].replace("not lonely ", "")
			lonelyType = 1
		elif "lonely " in rule[0]:
			affectedTile = rule[0].replace("lonely ", "")
			lonelyType = 0
		else:
			affectedTile = rule[0]
		if "not " in affectedTile:
			var notWhat = affectedTile.replace("not " , "")
			if (notWhat == tile_name || notWhat == "all"):
				continue
		else:
			if (affectedTile != tile_name && affectedTile != "all" && affectedTile != "level"):
				continue
		if (lonelyType != -1):
			if (!isTileLonely(tile, lonelyType)):
				continue
		var conditionOffset = 1
		var passed = true
		while true:
			var conditionText = rule[conditionOffset]
			var conditionInversed = "not " in conditionText
			if (conditionInversed):
				conditionText = conditionText.replace("not ", "")
			if (conditionText == "on" || conditionText == "near" || conditionText == "facing"):
				lonelyType = -1
				if "not lonely " in rule[conditionOffset + 1]:
					affectedTile = rule[conditionOffset + 1].replace("not lonely ", "")
					lonelyType = 1
				elif "lonely " in rule[conditionOffset + 1]:
					affectedTile = rule[conditionOffset + 1].replace("lonely ", "")
					lonelyType = 0
				else:
					affectedTile = rule[conditionOffset + 1]
				var conditionPassed = false
				if (conditionText == "facing" && (("left" in affectedTile) || ("right" in affectedTile) || ("up" in affectedTile) || ("down" in affectedTile))):
					if ("not " in affectedTile):
						if ("left" in affectedTile):
							if (tile.direction == 2):
								passed = false
								break
						if ("right" in affectedTile):
							if (tile.direction == 0):
								passed = false
								break
						if ("up" in affectedTile):
							if (tile.direction == 1):
								passed = false
								break
						if ("down" in affectedTile):
							if (tile.direction == 3):
								passed = false
								break
					else:
						if ("left" in affectedTile):
							if (tile.direction != 2):
								passed = false
								break
						if ("right" in affectedTile):
							if (tile.direction != 0):
								passed = false
								break
						if ("up" in affectedTile):
							if (tile.direction != 1):
								passed = false
								break
						if ("down" in affectedTile):
							if (tile.direction != 3):
								passed = false
								break
					conditionPassed = true
				
				if (!conditionPassed):
					for subTile in tiles:
						if ((("not " in affectedTile) && subTile.tileName != affectedTile.replace("not ", "") && affectedTile.replace("not ", "") != "all") || (!("not " in affectedTile) && (affectedTile == "all" || subTile.tileName == affectedTile))):
							if (conditionText == "on"):
								if (subTile.pos != tile.pos):
									continue
							elif (conditionText == "near"):
								if (subTile.pos.x == tile.pos.x - 1 && (subTile.pos.y == tile.pos.y - 1 || subTile.pos.y == tile.pos.y + 1 || subTile.pos.y == tile.pos.y)):
									pass
								elif (subTile.pos.x == tile.pos.x && (subTile.pos.y == tile.pos.y - 1 || subTile.pos.y == tile.pos.y + 1)):
									pass
								elif (subTile.pos.x == tile.pos.x + 1 && (subTile.pos.y == tile.pos.y - 1 || subTile.pos.y == tile.pos.y + 1 || subTile.pos.y == tile.pos.y)):
									pass
								else:
									continue
							elif (conditionText == "facing"):
								if (subTile.pos.x == tile.pos.x - 1 && subTile.pos.y == tile.pos.y):
									if (tile.direction != 2):
										continue
								elif (subTile.pos.x == tile.pos.x && subTile.pos.y == tile.pos.y + 1):
									if (tile.direction != 3):
										continue
								elif (subTile.pos.x == tile.pos.x && subTile.pos.y == tile.pos.y - 1):
									if (tile.direction != 1):
										continue
								elif (subTile.pos.x == tile.pos.x + 1 && subTile.pos.y == tile.pos.y):
									if (tile.direction != 0):
										continue
								else:
									continue
							if (lonelyType != -1):
								if (!isTileLonely(subTile, lonelyType)):
									continue
							conditionPassed = true
							break
				if (conditionInversed):
					conditionPassed = !conditionPassed
				if (!conditionPassed):
					passed = false
					break
				conditionOffset += 2
			else:
				break
		if (passed):
			var newRule = {}
			newRule[rule[conditionOffset]] = {}
			newRule[rule[conditionOffset]][rule[conditionOffset + 1]] = 1
			appliableRules.append(newRule)
			applyRuleInstantly(tile_name, rule[conditionOffset], rule[conditionOffset + 1])
	return appliableRules

# stub
func isTileLonely(tile, lonelyType) -> bool:
	return true

func ifOperatorUsed(tile_name, operator, tile) -> String:
	return ifOperatorUsed_cached(tile_name, operator, getAppliableRulesStatic(tile_name, worldRulesStatic, tile), getAppliableRulesDynamic(tile_name, worldRulesDynamic, tile))

func getRuleStackValue(tile_name, operator, action, tile) -> int:
	return getRuleStackValue_cached(tile_name, operator, action, getAppliableRulesStatic(tile_name, worldRulesStatic, tile), getAppliableRulesDynamic(tile_name, worldRulesDynamic, tile))

func ifOperatorUsed_cached(tile_name, operator, appliableStaticRules, appliableDynamicRules) -> String:
	
	# todo exclude if not is used
	
	for rule in appliableStaticRules:
		if (rule.has(operator)):
			return rule[operator][rule[operator].keys()[0]]

	for rule in appliableDynamicRules:
		if (rule.has(operator)):
			return rule[operator][rule[operator].keys()[0]]
	
	return ""

func ifRuleActive_cached(tile_name, operator, action, appliableStaticRules, appliableDynamicRules) -> bool:
	return ifRuleActiveRetro_cached(tile_name, operator, action, worldRulesStatic, worldRulesDynamic, appliableStaticRules, appliableDynamicRules)

func ifRuleActiveRetro_cached(tile_name, operator, action, worldRules, worldRulesDyn, appliableStaticRules, appliableDynamicRules) -> bool:	
	if !("not " in action):
		for rule in appliableStaticRules:
			if (rule.has(operator) && rule[operator].has("not " + action)):
				return false
		for rule in appliableDynamicRules:
			if (rule.has(operator) && rule[operator].has("not " + action)):
				return false
		
	for rule in appliableStaticRules:
		if (rule.has(operator) && rule[operator].has(action)):
			return true
			
	for rule in appliableDynamicRules:
		if (rule.has(operator) && rule[operator].has(action)):
			return true
	
	return false

func getRuleStackValue_cached(tile_name, operator, action, appliableStaticRules, appliableDynamicRules) -> int:
	var value = 0

	if !("not " in action):
		for rule in appliableStaticRules:
			if (rule.has(operator) && rule[operator].has("not " + action)):
				return 0
		for rule in appliableDynamicRules:
			if (rule.has(operator) && rule[operator].has("not " + action)):
				return 0

	for rule in appliableStaticRules:
		if (rule.has(operator) && rule[operator].has(action)):
			value += rule[operator][action]

	for rule in appliableDynamicRules:
		if (rule.has(operator) && rule[operator].has(action)):
			value += rule[operator][action]
	
	return value