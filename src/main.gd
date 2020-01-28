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

var currentLevel = 0

var barriers
var barrierTiles = []
var tiles = []
var solidTiles
var tilingMode3Tiles

var worldRulesStatic
var worldRulesDynamic
var dynamicRuleApplyabilityCache

var rulesStatic

var worldWidth
var worldHeight

var worldLerpTime
var worldAnimationFrame

var animtimer = 0

var unappliedMovement
var unappliedRules
var unappliedAutoTile

onready var tilePrefab = preload("res://src/tile.tscn")

var database
var loadedSprites
var palette

var controlsActive

var startTime = OS.get_ticks_msec()
var curTime = startTime

var musicPlayer
var soundPlayer
var noisePlayer
var BG
var you_found
var cam

func test_pong() -> void:
	worldWidth = 27
	worldHeight = 23
	loadPalette("default.png")
	
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
	loadPalette("default.png")
	
	spawnTileByName(0, 0, 0, "text_baba")
	spawnTileByName(1, 0, 0, "text_on")
	spawnTileByName(2, 0, 0, "text_rock")
	spawnTileByName(3, 0, 0, "text_is")
	spawnTileByName(4, 0, 0, "text_wall")
	spawnTileByName(0, 1, 0, "text_is")
	spawnTileByName(0, 2, 0, "text_you")
	
	spawnTileByName(2, 2, 0, "baba")
	spawnTileByName(3, 2, 0, "rock")
	
	for y in range(0, worldHeight):
		for x in range(0, worldWidth):
			spawnTileByName(x, y, 0, "tile")

func test_paint() -> void:
	worldWidth = 12
	worldHeight = 12
	loadPalette("default.png")
	
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

func test_secret() -> void:
	worldWidth = 14
	worldHeight = 14
	loadPalette("variant.png")
	
	spawnTileByName(0, 0, 0, "text_baba")
	spawnTileByName(1, 0, 0, "text_on")
	spawnTileByName(2, 0, 0, "text_wall")
	spawnTileByName(3, 0, 0, "text_and")
	spawnTileByName(4, 0, 0, "text_text")
	spawnTileByName(5, 0, 0, "text_and")
	spawnTileByName(6, 0, 0, "text_baba")
	spawnTileByName(7, 0, 0, "text_and")
	spawnTileByName(8, 0, 0, "text_rock")
	spawnTileByName(9, 0, 0, "text_and")
	spawnTileByName(10, 0, 0, "text_flag")
	spawnTileByName(11, 0, 0, "text_is")
	spawnTileByName(12, 0, 0, "text_win")
	spawnTileByName(13, 0, 0, "hedge")
	
	spawnTileByName(0, 1, 0, "text_is")
	spawnTileByName(1, 1, 0, "hedge")
	spawnTileByName(2, 1, 0, "text_is")
	for x in range(3, 14):
		spawnTileByName(x, 1, 0, "hedge")

	spawnTileByName(0, 2, 0, "text_you")
	spawnTileByName(1, 2, 0, "hedge")
	spawnTileByName(2, 2, 0, "text_stop")
	spawnTileByName(3, 2, 0, "hedge")

	for x in range(0, 4):
		spawnTileByName(x, 3, 0, "hedge")

	for x in range(8, 13):
		spawnTileByName(x, 3, 0, "wall")

	spawnTileByName(0, 4, 0, "text_hedge")
	spawnTileByName(1, 4, 0, "text_is")
	spawnTileByName(2, 4, 0, "text_stop")
	spawnTileByName(3, 4, 0, "hedge")

	for x in range(0, 4):
		spawnTileByName(x, 5, 0, "hedge")
	
	spawnTileByName(5, 5, 0, "flag")
	
	spawnTileByName(10, 5, 2, "baba")

	for x in range(8, 13):
		spawnTileByName(x, 7, 0, "wall")

	for y in range(4, 7):
		spawnTileByName(12, y, 0, "wall")
	
	spawnTileByName(8, 4, 0, "wall")
	spawnTileByName(8, 6, 0, "wall")
	
	spawnTileByName(3, 10, 0, "text_baba")
	
	spawnTileByName(5, 10, 0, "text_rock")
	spawnTileByName(6, 10, 0, "text_is")
	spawnTileByName(7, 10, 0, "text_push")
	
	spawnTileByName(10, 10, 0, "rock")
	
	spawnTileByName(3, 12, 0, "text_on")
	
	spawnTileByName(6, 12, 0, "text_wall")
	spawnTileByName(7, 12, 0, "text_is")
	spawnTileByName(8, 12, 0, "text_shift")
	
	spawnTileByName(10, 12, 0, "rock")

func _ready():
	
	musicPlayer = get_node("/root/root/Music")
	soundPlayer = get_node("/root/root/Sound")
	noisePlayer = get_node("/root/root/Noise")
	cam = get_node("/root/root/Camera2D")
	BG = get_node("/root/root/BG")
	get_node("/root/root/UI/Prev").connect("pressed", self, "prevLevel")
	get_node("/root/root/UI/Next").connect("pressed", self, "nextLevel")

	loadLevel(currentLevel)
	#preLoadAction()
	#test_secret()
	#postLoadAction()

func preLoadAction() -> void:
	for tile in tiles:
		remove_child(tile)
	for tile in barrierTiles:
		remove_child(tile)
	barriers = {}
	barrierTiles = []
	tiles = []
	solidTiles = []
	tilingMode3Tiles = []
	worldRulesStatic = {}
	worldRulesDynamic = []
	dynamicRuleApplyabilityCache = {}
	rulesStatic = {}
	you_found = true
	controlsActive = true
	loadedSprites = {}
	unappliedAutoTile = false
	unappliedRules = false
	unappliedMovement = null
	worldAnimationFrame = 0
	worldLerpTime = 1
	database = load("res://src/database.gd").tiles

func postLoadAction() -> void:
	# applying camera stuff
	cam.position = Vector2(round(float(worldWidth * 24) / 2.0), round(float(worldHeight * 24) / 2.0))
	var display_size = OS.get_screen_size()
	var zoom
	if (float(worldWidth) / float(worldHeight) > float(display_size.x) / float(display_size.y)):
		zoom = float(worldWidth * 24) / float(display_size.x)
	else:
		zoom = float(worldHeight * 24) / float(display_size.y)
	cam.zoom = Vector2.ONE * zoom
	BG.rect_size = Vector2(worldWidth * 24, worldHeight * 24)
	
	print("game is start")
	
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
	preLoadAction()
	
	print("parsing level " + str(levelNum) + " config")
	# load metadata
	var level = ConfigFile.new()
	var file = File.new()
	file.open("res://levels/" + str(levelNum) + "level.ld.txt", File.READ)
	var currentGroup = ""
	for line in file.get_as_text().split("\n"):
		if (line.length() == 0):
			continue
		if (line[0] == "["):
			currentGroup = line.replace("[", "").replace("]", "")
		else:
			if !("=" in line):
				continue
			var content = line.split("=")[1]
			if (content.length() != 0):
				if "," in content:
					var subentries = content.split(",", false)
					content = []
					for entry in subentries:
						if (entry[0] != "-" && entry[0] != "0" && entry[0] != "1" && entry[0] != "2" && entry[0] != "3" && entry[0] != "4" && entry[0] != "5" && entry[0] != "6" && entry[0] != "7" && entry[0] != "8" && entry[0] != "9"):
							content.append(entry)
						else:
							content.append(int(entry))
				else:
					var numberical = true
					for l in content:
						if (l != "-" && l != "0" && l != "1" && l != "2" && l != "3" && l != "4" && l != "5" && l != "6" && l != "7" && l != "8" && l != "9"):
							numberical = false
							break
					if (numberical):
						content = int(content)
			level.set_value(currentGroup, line.split("=")[0], content)
	file.close()
	
	var levelName = level.get_value("general", "name", "")
	var levelDesc = level.get_value("general", "subtitle", "")
	print("level " + levelName + ": " + levelDesc)
	
	loadPalette(level.get_value("general", "palette", "default.png"))
	
	var objectCount = level.get_value("general", "currobjlist_total", 0)
	var curobjlist = []
	for objectNum in range(1, objectCount + 1):
		var obj = {}
		obj["id"] = level.get_value("currobjlist", str(objectNum) + "id")
		obj["name"] = level.get_value("currobjlist", str(objectNum) + "name")
		obj["object"] = level.get_value("currobjlist", str(objectNum) + "object")
		obj["gox"] = level.get_value("currobjlist", str(objectNum) + "gox")
		obj["goy"] = level.get_value("currobjlist", str(objectNum) + "goy")
		obj["gfx"] = level.get_value("currobjlist", str(objectNum) + "gfx")
		obj["gfy"] = level.get_value("currobjlist", str(objectNum) + "gfy")
		obj["pair"] = level.get_value("currobjlist", str(objectNum) + "pair")
		curobjlist.append(obj)
	
	var changedTiles = level.get_value("tiles", "changed", [])
	for changedTile in changedTiles:
		if (!database.has(changedTile)):
			database[changedTile] = {}
		if (level.has_section_key("tiles", changedTile + "_image")):
			database[changedTile]["sprite"] = level.get_value("tiles", changedTile + "_image")
		if (level.has_section_key("tiles", changedTile + "_name")):
			database[changedTile]["name"] = level.get_value("tiles", changedTile + "_name")
		if (level.has_section_key("tiles", changedTile + "_unittype")):
			database[changedTile]["unittype"] = level.get_value("tiles", changedTile + "_unittype")
		if (level.has_section_key("tiles", changedTile + "_type")):
			database[changedTile]["type"] = level.get_value("tiles", changedTile + "_type")
		if (level.has_section_key("tiles", changedTile + "_tiling")):
			database[changedTile]["tiling"] = level.get_value("tiles", changedTile + "_tiling")
		if (level.has_section_key("tiles", changedTile + "_colour")):
			database[changedTile]["colour"] = level.get_value("tiles", changedTile + "_colour")
		if (level.has_section_key("tiles", changedTile + "_activecolour")):
			database[changedTile]["active"] = level.get_value("tiles", changedTile + "_activecolour")
		if (level.has_section_key("tiles", changedTile + "_argextra")):
			database[changedTile]["argextra"] = level.get_value("tiles", changedTile + "_argextra")
		if (level.has_section_key("tiles", changedTile + "_tile")):
			database[changedTile]["tile"] = level.get_value("tiles", changedTile + "_tile")
	
	print("parsing binary")
	# code ported from https://github.com/ShootMe/BabaIsYouEditor
	file = File.new()
	var err = file.open("res://levels/" + str(levelNum) + "level.l.txt", File.READ)
	
	if (err != OK):
		push_error("error loading binary: " + str(err))
		postLoadAction()
		return
	
	if (file.get_64() != 0x21474e5554484341): # ACHTUNG
		push_error("invalid map file")
		postLoadAction()
		return
	
	var version = file.get_16()
	if (version < 256 || version > 261):
		push_error("unsupported map version")
		postLoadAction()
		return
	
	var file_size = file.get_len()
	while (file.get_position() < file_size):
		var blockHeader = file.get_32()
		file.get_32()
		if (blockHeader == 0x2050414d): # MAP
			file.get_16()
		elif (blockHeader == 0x5259414c): # LAYR
			var ids = []
			var directions = []
			var layerCount = file.get_16()
			for i in range(0, layerCount):
				worldWidth = file.get_32()
				worldHeight = file.get_32()
				if (version >= 258):
					file.get_32()
				for j in range(0, 25):
					file.get_8()
				if (version == 260):
					file.get_16()
				elif (version == 261):
					file.get_16()
					file.get_8()
				var size = worldWidth * worldHeight
				var dataBlocks = file.get_8()
				if (dataBlocks < 1 || dataBlocks > 2):
					push_error("invalid data block count")
					file.close()
					postLoadAction()
					return
				# MAIN
				file.get_32()
				var compressedSize = file.get_32()
				var nextPosition = file.get_position() + compressedSize
				var file2 = File.new()
				file2.open("user://temp", File.WRITE)
				file2.store_32(0x46504347)
				file2.store_32(0x00000001)
				file2.store_32(0x00001000)
				file2.store_32(size * 2)
				file2.store_32(compressedSize)
				for p in range(0, compressedSize):
					file2.store_8(file.get_8())
				file2.store_32(0x00000000)
				file2.store_32(0x46504347)
				file2.close()
				err = file2.open_compressed("user://temp", File.READ, 1)
				if (err != OK):
					push_error("decompression error: " + str(err))
					file.close()
					postLoadAction()
					return
				while (file2.get_position() < size * 2):
					ids.append(file2.get_16())
				file2.close()
				file.seek(nextPosition)
				if (dataBlocks == 2):
					# DATA
					for j in range(0, 9):
						file.get_8()
					compressedSize = file.get_32()
					nextPosition = file.get_position() + compressedSize
					file2 = File.new()
					file2.open("user://temp", File.WRITE)
					file2.store_32(0x46504347)
					file2.store_32(0x00000001)
					file2.store_32(0x00001000)
					file2.store_32(size)
					file2.store_32(compressedSize)
					for p in range(0, compressedSize):
						file2.store_8(file.get_8())
					file2.store_16(0x00000000)
					file2.store_32(0x46504347)
					file2.close()
					err = file2.open_compressed("user://temp", File.READ, 1)
					if (err != OK):
						push_error("decompression error: " + str(err))
						file.close()
						postLoadAction()
						return
					var results = []
					while (file2.get_position() < size):
						directions.append(file2.get_8())
					file2.close()
					file.seek(nextPosition)
				var dir = Directory.new()
				dir.remove("user://temp")
			
			var x = 0
			var y = 0
			
			for idNum in range(0, worldWidth * worldHeight):
				var curTile = null
				if (ids[idNum] == 0):
					spawnBarrier(x, y)
				elif (ids[idNum] == 65535):
					pass
				else:
					for tile in database.keys():
						var database_entry = database[tile]
						var id = ((database_entry["tile"][1] << 8) | database_entry["tile"][0])
						if (id == ids[idNum]):
							curTile = tile
							break
					if (curTile != null):
						spawnTile(x, y, directions[idNum], curTile)
					else:
						push_error("unknown tile id " + ids[idNum])
						spawnTile(x, y, directions[idNum], "")
				x += 1
				if (x >= worldWidth):
					x = 0
					y += 1
	
	file.close()
	
	print("loading done")
	
	postLoadAction()

var paletteMusic = {
	"abstract.png": "baba.ogg",
	"autumn.png": "forest.ogg", # ?
	"contrast.png": "baba.ogg",
	"default.png": "baba.ogg",
	"factory.png": "factory.ogg",
	"garden.png": "garden.ogg",
	"marshmallow.png": "baba.ogg",
	"mono.png": "baba.ogg",
	"mountain.png": "mountain.ogg",
	"ocean.png": "float.ogg", # ?
	"ruins.png": "ruin.ogg",
	"space.png": "stars.ogg",
	"swamp.png": "forest.ogg", # ?
	"test.png": "baba.ogg",
	"variant.png": "baba.ogg",
	"volcano.png": "burn.ogg" # ?
}

var curpalette = ""
var curmusic = ""

func loadPalette(fileName) -> void:
	if (curpalette == fileName):
		return
	curpalette = fileName
	if (palette != null):
		palette.unlock()
	palette = load("res://palettes/" + fileName).get_data()
	palette.lock()
	VisualServer.set_default_clear_color(palette.get_pixel(1, 0))
	BG.color = palette.get_pixel(6, 4)
	loadMusic(paletteMusic[fileName])
	print("palette changed to " + fileName)

func loadMusic(fileName) -> void:
	if (curmusic == fileName):
		return
	curmusic = fileName
	musicPlayer.stream = load("res://music/" + fileName)
	musicPlayer.playing = true;
	print("music changed to " + fileName)

func _process(delta):
	curTime = OS.get_ticks_msec() - startTime
	animtimer += min(delta, 0.2)
	musicPlayer.volume_db = lerp(musicPlayer.volume_db, 0 if you_found else -80, min(delta * 2, 1))
	noisePlayer.volume_db = -musicPlayer.volume_db - 80
	if (animtimer > 0.2):
		animtimer -= 0.2
		worldAnimationFrame += 1
		if (worldAnimationFrame > 2):
			worldAnimationFrame = 0
		for tile in tiles:
			tile.updateSpriteAnim()
	if (worldLerpTime < 1):
		worldLerpTime += delta * 10

var swipe_start = null
var minimum_drag = 100
        
func _calculate_swipe(swipe_end):
	var swipe = swipe_end - swipe_start
	push_error("swipe " + str(swipe.x) + str(swipe.y))
	if (worldLerpTime < 1 || !controlsActive):
		return
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			input_process(Vector2.RIGHT)
		else:
			input_process(Vector2.LEFT)
	elif abs(swipe.y) > minimum_drag:
		if swipe.y > 0:
			input_process(Vector2.DOWN)
		else:
			input_process(Vector2.UP)
	else:
		input_process(Vector2.ZERO)

func prevLevel() -> void:
	if (currentLevel > 0):
		currentLevel -= 1
		loadLevel(currentLevel)

func nextLevel() -> void:
	if (currentLevel < 329):
		currentLevel += 1
		loadLevel(currentLevel)

func _input(ev):
	if (Input.is_key_pressed(KEY_1)):
		prevLevel()
	elif (Input.is_key_pressed(KEY_2)):
		nextLevel()
	if (worldLerpTime < 1 || !controlsActive):
		return
	if Input.is_key_pressed(KEY_SPACE):
		input_process(Vector2.ZERO)
	elif Input.is_key_pressed(KEY_RIGHT):
		input_process(Vector2.RIGHT)
	elif Input.is_key_pressed(KEY_UP):
		input_process(Vector2.UP)
	elif Input.is_key_pressed(KEY_LEFT):
		input_process(Vector2.LEFT)
	elif Input.is_key_pressed(KEY_DOWN):
		input_process(Vector2.DOWN)
	if ev.is_action_pressed("click"):
		swipe_start = get_viewport().get_mouse_position()
	if ev.is_action_released("click"):
		_calculate_swipe(get_viewport().get_mouse_position())

func input_process(mov) -> void:
	unappliedMovement = mov
	worldLerpTime = 0
	updateWorld()
	if (unappliedAutoTile):
		unappliedAutoTile = false
		updateAutoTile()

func spawnTileByName(x, y, direction, tileName) -> Node:
	return spawnTile(x, y, direction, findTileId(tileName))

func spawnBarrier(x, y) -> void:
	if (!barriers.has(x)):
		barriers[x] = []
	barriers[x].append(y)
	var spawnedTile = BG.duplicate()
	add_child(spawnedTile)
	spawnedTile.rect_position = Vector2(x * 24, y * 24)
	spawnedTile.rect_size = Vector2(24, 24)
	spawnedTile.color = palette.get_pixel(1, 0)
	barrierTiles.append(spawnedTile)

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
	
	if (!database.has(name)):
		push_error("unknown tile " + name)
		tile.tileName = "unknown"
		tile.tileId = "unknown"
		tile.isFloating = true
		tile.isSleeping = false
		tile.visible = false
		tile.tileType = 0
		tile.tilingMode = -1
		if (!loadedSprites.has("unknown")):
			loadedSprites["unknown"] = []
			loadSprite("unknown", "what_0")
		return
	
	tile.tileName = database[name]["name"]
	tile.tileId = name
	
	tile.isFloating = ifRuleActive(tile.tileName, "is", "float", tile, false)
	tile.isSleeping = ifRuleActive(tile.tileName, "is", "sleep", tile, false)
	tile.visible = !ifRuleActive(tile.tileName, "is", "hide", tile, false)
	
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
		if (tile.tilingMode == 3):
			if (!tilingMode3Tiles.has(tile)):
				tilingMode3Tiles.append(tile)
		elif (tilingMode3Tiles.has(tile)):
			tilingMode3Tiles.erase(tile)
	else:
		unappliedAutoTile = true
		if (tilingMode3Tiles.has(tile)):
			tilingMode3Tiles.erase(tile)
	
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
		elif (tile.tilingMode == 0):
			for i in [8, 16, 24]:
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

func destroyTile(tile, forced = false, replace = true) -> bool:
	if (!forced && ifRuleActive(tile.tileName, "is", "safe", tile, false)):
		return false
	if (replace):
		if (ifOperatorUsed(tile.tileName, "has", tile)):
			for rule in rulesStatic[tile.tileName] + rulesDynamic[tile]:
				if (rule.has("has")):
					for tileName in rule["has"].keys():
						changeTileType(tile, findTileId(tileName))
						unappliedRules = true
						return false
	unappliedRules = true
	if (tile.tilingMode == 1):
		unappliedAutoTile = true
	elif (tile.tilingMode == 3):
		tilingMode3Tiles.erase(tile)
	tiles.erase(tile)
	remove_child(tile)
	updateWorld_running = true
	return true

func findTileId(name) -> String:
	for key in database.keys():
		if (database[key]["name"] == name):
			return key
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

var justTeleported = []
var justShifted = []
var justSpawned = []
var rulesDynamic = {}
var tilesTrimmed = []
var rs
var rd

func updateWorld_rulesUpdate() -> void:
	unappliedRules = false
	checkTheRules()
	tilesTrimmed = []
	solidTiles = []
	for tile in tiles:
		rulesDynamic[tile] = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, dynamicRuleApplyabilityCache, tile)
		if (rulesStatic[tile.tileName].size() > 0 || rulesDynamic[tile].size() > 0):
			tilesTrimmed.append(tile)
			if (is_tile_solid(tile, rulesStatic, rulesDynamic)):
				solidTiles.append(tile)
		elif (tile.tileType != 0):
			solidTiles.append(tile)

var updateWorld_running = false

func updateWorld() -> void:
	justTeleported = []
	justShifted = []
	justSpawned = []
	rulesDynamic = {}
	tilesTrimmed = []
	solidTiles = []
	for tile in tilingMode3Tiles:
		tile.updateWalkFrame()
		tile.updateSpriteAnim()
	for tile in tiles:
		rulesDynamic[tile] = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, dynamicRuleApplyabilityCache, tile)
		if (rulesStatic[tile.tileName].size() > 0 || rulesDynamic[tile].size() > 0):
			tilesTrimmed.append(tile)
			tile.isFloating = ifRuleActive_cached(tile.tileName, "is", "float", rulesStatic[tile.tileName], rulesDynamic[tile])
			tile.isSleeping = ifRuleActive_cached(tile.tileName, "is", "sleep", rulesStatic[tile.tileName], rulesDynamic[tile])
			tile.visible = !ifRuleActive_cached(tile.tileName, "is", "hide", rulesStatic[tile.tileName], rulesDynamic[tile])
			if (is_tile_solid(tile, rulesStatic, rulesDynamic)):
				solidTiles.append(tile)
		else:
			tile.isFloating = false
			tile.isSleeping = false
			tile.visible = true
			if (tile.tileType != 0):
				solidTiles.append(tile)
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
		for tile in tilesTrimmed:
			rs = rulesStatic[tile.tileName]
			rd = rulesDynamic[tile]
			if (ifRuleActive_cached(tile.tileName, "is", "you", rs, rd)):
				if (!tile.isSleeping && unappliedMovement != Vector2.ZERO):
					you_found = true
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
	tilesTrimmed = []
	solidTiles = []
	for tile in tiles:
		rulesDynamic[tile] = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, dynamicRuleApplyabilityCache, tile)
		if (rulesStatic[tile.tileName].size() > 0 || rulesDynamic[tile].size() > 0):
			tilesTrimmed.append(tile)
			if (is_tile_solid(tile, rulesStatic, rulesDynamic)):
				solidTiles.append(tile)
		elif (tile.tileType != 0):
			solidTiles.append(tile)
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
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
	tilesTrimmed = []
	solidTiles = []
	for tile in tiles:
		rulesDynamic[tile] = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, dynamicRuleApplyabilityCache, tile)
		if (rulesStatic[tile.tileName].size() > 0 || rulesDynamic[tile].size() > 0):
			tilesTrimmed.append(tile)
			if (is_tile_solid(tile, rulesStatic, rulesDynamic)):
				solidTiles.append(tile)
		elif (tile.tileType != 0):
			solidTiles.append(tile)
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
		for tile in tilesTrimmed:
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
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
		for tile in tilesTrimmed:
			rs = rulesStatic[tile.tileName]
			rd = rulesDynamic[tile]
			if (ifRuleActive_cached(tile.tileName, "is", "done", rs, rd)):
				destroyTile(tile, true)
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
		for tile in tilesTrimmed:
			rs = rulesStatic[tile.tileName]
			rd = rulesDynamic[tile]
			if (ifRuleActive_cached(tile.tileName, "is", "sink", rs, rd)):
				var running = true
				while (running):
					running = false
					for subTile in tiles:
						if (subTile != tile && subTile.pos == tile.pos):
							if (destroyTile(subTile)):
								running = true
							destroyTile(tile)
							break
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
		for tile in tilesTrimmed:
			rs = rulesStatic[tile.tileName]
			rd = rulesDynamic[tile]
			if (ifRuleActive_cached(tile.tileName, "is", "hot", rs, rd)):
				var running = true
				while (running):
					running = false
					for subTile in tiles:
						if (subTile.pos == tile.pos && ifRuleActive_cached(subTile.tileName, "is", "melt", rulesStatic[subTile.tileName], rulesDynamic[subTile])):
							if (destroyTile(subTile)):
								running = true
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
		for tile in tilesTrimmed:
			rs = rulesStatic[tile.tileName]
			rd = rulesDynamic[tile]
			if (ifRuleActive_cached(tile.tileName, "is", "defeat", rs, rd)):
				var running = true
				while (running):
					running = false
					for subTile in tiles:
						if (subTile.pos == tile.pos && ifRuleActive_cached(subTile.tileName, "is", "you", rulesStatic[subTile.tileName], rulesDynamic[subTile])):
							if (destroyTile(subTile)):
								running = true
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
		for tile in tilesTrimmed:
			rs = rulesStatic[tile.tileName]
			rd = rulesDynamic[tile]
			if (ifRuleActive_cached(tile.tileName, "is", "shut", rs, rd)):
				var running = true
				while (running):
					running = false
					for subTile in tiles:
						if (ifRuleActive_cached(subTile.tileName, "is", "open", rs, rd)):
							if (destroyTile(subTile)):
								running = true
							destroyTile(tile)
							break
	# unspecified order
	updateWorld_running = true
	while (updateWorld_running):
		updateWorld_running = false
		if (unappliedRules):
			updateWorld_rulesUpdate()
		for tile in tilesTrimmed:
			if (justSpawned.has(tile)):
				continue
			rs = rulesStatic[tile.tileName]
			rd = rulesDynamic[tile]
			if (ifRuleActive_cached(tile.tileName, "is", "win", rs, rd) || ifRuleActive_cached(tile.tileName, "is", "end", rs, rd)):
				for subtile in tiles:
					if (subtile.pos == tile.pos && ifRuleActive_cached(subtile.tileName, "is", "you", rulesStatic[subtile.tileName], rulesDynamic[subtile])):
						controlsActive = false
			if (ifRuleActive_cached(tile.tileName, "is", "more", rs, rd)):
				var upFree = tile.pos.y > 0
				var downFree = tile.pos.y < worldHeight - 1
				var leftFree = tile.pos.x > 0
				var rightFree = tile.pos.x < worldWidth - 1
				var counter = 0
				for subtile in tiles:
					if (subtile.tileId == tile.tileId || is_tile_solid(subtile, rs, rd)):
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
	if (unappliedRules):
		unappliedRules = false
		checkTheRules()
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

func yeet_tile(tile, delta_x, delta_y, rulesStatic, rulesDynamic) -> void:
	while (true):
		if (!push_tile(tile, delta_x, delta_y, rulesStatic, rulesDynamic)):
			return;

func push_tile(tile, delta_x, delta_y, rulesStatic, rulesDynamic, moveMode = false, moveModeRule = "move") -> bool:
	if (ifRuleActive_cached(tile.tileName, "is", "fall", rulesStatic[tile.tileName], rulesDynamic[tile]) && delta_y < 0):
		return false
	var newX = int(tile.pos.x + delta_x)
	var newY = int(tile.pos.y + delta_y)
	var oppositeX = int(tile.pos.x - delta_x)
	var oppositeY = int(tile.pos.y - delta_y)
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (barriers.has(newX) && barriers[newX].has(newY)):
		return false
	var swapMode = ifRuleActive_cached(tile.tileName, "is", "swap", rulesStatic[tile.tileName], rulesDynamic[tile])
	var weakMode = ifRuleActive_cached(tile.tileName, "is", "weak", rulesStatic[tile.tileName], rulesDynamic[tile])
	var openMode = ifRuleActive_cached(tile.tileName, "is", "open", rulesStatic[tile.tileName], rulesDynamic[tile])
	var pushableTiles = []
	var pullableTiles = []
	for pushedTile in solidTiles:
		if (pushedTile.pos.x == newX && pushedTile.pos.y == newY):
			if ((!weakMode || swapMode) && (!openMode || !ifRuleActive_cached(pushedTile.tileName, "is", "shut", rulesStatic[pushedTile.tileName], rulesDynamic[pushedTile]))):
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
			if (!can_be_pulled(pushedTile, delta_x, delta_y, rulesStatic, rulesDynamic)):
				continue
			pullableTiles.append(pushedTile)
	for pulledTile in pullableTiles:
		pull_tile(pulledTile, delta_x, delta_y, rulesStatic, rulesDynamic)
	if (weakMode && !swapMode && pushableTiles.size() > 0):
		if (destroyTile(tile)):
			return true
	for pushedTile in pushableTiles:
		if (openMode && ifRuleActive_cached(pushedTile.tileName, "is", "shut", rulesStatic[pushedTile.tileName], rulesDynamic[pushedTile])):
			destroyTile(tile)
			destroyTile(pushedTile)
			return true
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
						rulesDynamic[result] = getAppliableRulesDynamic(result.tileName, worldRulesDynamic, dynamicRuleApplyabilityCache, result)
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
	var newX = int(tile.pos.x + delta_x)
	var newY = int(tile.pos.y + delta_y)
	var oppositeX = int(tile.pos.x - delta_x)
	var oppositeY = int(tile.pos.y - delta_y)
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (barriers.has(newX) && barriers[newX].has(newY)):
		return false
	var pullableTiles = []
	for pushedTile in solidTiles:
		if (pushedTile.pos.x == oppositeX && pushedTile.pos.y == oppositeY):
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
	var newX = int(tile.pos.x + delta_x)
	var newY = int(tile.pos.y + delta_y)
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (barriers.has(newX) && barriers[newX].has(newY)):
		return false
	if (!moveMode || !ifRuleActive_cached(tile.tileName, "is", moveModeRule, rulesStatic[tile.tileName], rulesDynamic[tile])):
		if (ifRuleActive_cached(tile.tileName, "is", "stop", rulesStatic[tile.tileName], rulesDynamic[tile])):
			return false
		if (tile.tileType == 0 && !ifRuleActive_cached(tile.tileName, "is", "push", rulesStatic[tile.tileName], rulesDynamic[tile])):
			return false
	var swapMode = ifRuleActive_cached(tile.tileName, "is", "swap", rulesStatic[tile.tileName], rulesDynamic[tile])
	var weakMode = ifRuleActive_cached(tile.tileName, "is", "weak", rulesStatic[tile.tileName], rulesDynamic[tile])
	var openMode = ifRuleActive_cached(tile.tileName, "is", "open", rulesStatic[tile.tileName], rulesDynamic[tile])
	for pushedTile in solidTiles:
		if (pushedTile.pos.x == newX && pushedTile.pos.y == newY):
			if (!swapMode && !weakMode && (!openMode || !ifRuleActive_cached(pushedTile.tileName, "is", "shut", rulesStatic[pushedTile.tileName], rulesDynamic[pushedTile]))):
				if (!can_be_pushed(pushedTile, delta_x, delta_y, tile, rulesStatic, rulesDynamic, moveMode, moveModeRule)):
					return false
	return true

func can_be_pulled(tile, delta_x, delta_y, rulesStatic, rulesDynamic) -> bool:
	var newX = int(tile.pos.x + delta_x)
	var newY = int(tile.pos.y + delta_y)
	if (newX < 0 || newX > worldWidth - 1 || newY < 0 || newY > worldHeight - 1):
		return false
	if (barriers.has(newX) && barriers[newX].has(newY)):
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
	tiles.sort_custom(self, "tileSorter")
	var worldRulesOld = worldRulesStatic
	var worldRulesDynOld = worldRulesDynamic
	var worldRulesDynOldCache = dynamicRuleApplyabilityCache
	worldRulesStatic = {}
	worldRulesDynamic = []
	dynamicRuleApplyabilityCache = {}
	var usedHorizontally = []
	var usedVertically = []
	you_found = false
	for tile in tiles:
		if (tile.tileType != 0):
			changeTileType(tile, tile.tileId)
	for tile in tiles:
		if (!usedVertically.has(tile)):
			checkTileRules(tile, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, true, usedVertically)
		if (!usedHorizontally.has(tile)):
			checkTileRules(tile, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, false, usedHorizontally)
	rulesStatic = {}
	for tile in tiles:
		if (!rulesStatic.has(tile.tileName)):
			rulesStatic[tile.tileName] = getAppliableRulesStatic(tile.tileName, worldRulesStatic, tile)
		var rulesCacheDynamic = getAppliableRulesDynamic(tile.tileName, worldRulesDynamic, dynamicRuleApplyabilityCache, tile)
		if (!rulesStatic.has(tile.tileName)):
			rulesStatic[tile.tileName] = getAppliableRulesStatic(tile.tileName, worldRulesStatic, tile)
		tile.isFloating = ifRuleActive_cached(tile.tileName, "is", "float", rulesStatic[tile.tileName], rulesCacheDynamic)
		tile.isSleeping = ifRuleActive_cached(tile.tileName, "is", "sleep", rulesStatic[tile.tileName], rulesCacheDynamic)
		tile.visible = !ifRuleActive_cached(tile.tileName, "is", "hide", rulesStatic[tile.tileName], rulesCacheDynamic)
	unappliedRules = false

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

func checkTileRules(tile, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTilesGlobal) -> void:
	var finalRule = []
	var usedTiles = []
	
	# build nouns
	var usedAnd = null
	var oldEnd = null
	var endTile = null
	finalRule.append([])
	while true:
		endTile = grabNoun(tile, finalRule[0], worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, true, usedTiles)
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
				if (nounTile.tileType == 1 || nounTile.tileType == 4 || nounTile.tileType == 7 || nounTile.tileType == 0 && ifRuleActiveRetro(nounTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, nounTile)):
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
		endTile = grabProperty(tile, finalRule, vertical, usedTiles, isTileName, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache)
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

func grabProperty(tile, container, vertical, usedTiles, isTileName, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache) -> Node:
	for propTile in tiles:
		if (vertical && propTile.pos == tile.pos + Vector2.DOWN || !vertical && propTile.pos == tile.pos + Vector2.RIGHT):
			if (propTile.tileType == 3 || propTile.tileType == 1 || ifRuleActiveRetro(propTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, propTile)):
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
						if (propTile2.tileType == 3 || propTile.tileType == 1 || ifRuleActiveRetro(propTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, propTile)):
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

func grabNoun(tile, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, conditionAllowed, usedTiles) -> Node:
	if (tile.tileType == 1 || tile.tileType == 4 || tile.tileType == 7 || tile.tileType == 0 && ifRuleActiveRetro(tile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, tile)):
		if (tile.tileType == 4):
			for subTile in tiles:
				if (vertical && subTile.pos == tile.pos + Vector2.DOWN || !vertical && subTile.pos == tile.pos + Vector2.RIGHT):
					if (subTile.tileType == 1 || ifRuleActiveRetro(subTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, subTile)):
						# not smh
						container.append("not " + subTile.tileName.split("_")[1] if subTile.tileType == 1 else subTile.tileName)
						usedTiles.append(tile)
						usedTiles.append(subTile)
						if (conditionAllowed):
							return grabCondition(subTile, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
						return subTile
					elif (subTile.tileType == 7):
						for subTile2 in tiles:
							if (vertical && subTile2.pos == subTile.pos + Vector2.DOWN || !vertical && subTile2.pos == subTile.pos + Vector2.RIGHT):
								if (subTile2.tileType == 1 || ifRuleActiveRetro(subTile2.tileName, "is", "word", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, subTile2)):
									# not lonely smh
									container.append("not lonely " + subTile2.tileName.split("_")[1] if subTile2.tileType == 1 else subTile2.tileName)
									usedTiles.append(tile)
									usedTiles.append(subTile)
									usedTiles.append(subTile2)
									if (conditionAllowed):
										return grabCondition(subTile2, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
									return subTile2
								if (subTile2.tileType == 4):
									# not lonely not smh
									# todo
									return null
			return null
		if (tile.tileType == 7):
			for subTile in tiles:
				if (vertical && subTile.pos == tile.pos + Vector2.DOWN || !vertical && subTile.pos == tile.pos + Vector2.RIGHT):
					if (subTile.tileType == 1 || ifRuleActiveRetro(subTile.tileName, "is", "word", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, subTile)):
						# lonely smh
						container.append("lonely " + subTile.tileName.split("_")[1] if subTile.tileType == 1 else subTile.tileName)
						usedTiles.append(tile)
						usedTiles.append(subTile)
						if (conditionAllowed):
							return grabCondition(subTile, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
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
			return grabCondition(tile, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
		return tile
	return null

func grabCondition(tile, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles) -> Node:
	for subTile in tiles:
		if (vertical && subTile.pos == tile.pos + Vector2.DOWN || !vertical && subTile.pos == tile.pos + Vector2.RIGHT):
			if (subTile.tileType == 6):
				if (subTile.tileName == "text_facing"):
					container.append(subTile.tileName.split("_")[1])
					var result = grabProperty(subTile, container, vertical, usedTiles, "", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache)
					if (result == null):
						container.remove(container.size() - 1)
					else:
						usedTiles.append(subTile)
						return grabConditionCheckForAdditional(result, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
				for subTile2 in tiles:
					if (vertical && subTile2.pos == subTile.pos + Vector2.DOWN || !vertical && subTile2.pos == subTile.pos + Vector2.RIGHT):
						container.append(subTile.tileName.split("_")[1])
						var result = grabNoun(subTile2, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, false, usedTiles)
						if (result == null):
							container.remove(container.size() - 1)
							continue
						usedTiles.append(subTile)
						return grabConditionCheckForAdditional(result, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
			elif (subTile.tileType == 4):
				for subTile3 in tiles:
					if (vertical && subTile3.pos == subTile.pos + Vector2.DOWN || !vertical && subTile3.pos == subTile.pos + Vector2.RIGHT):
						if (subTile3.tileType == 6):
							if (subTile3.tileName == "text_facing"):
								container.append("not " + subTile3.tileName.split("_")[1])
								var result = grabProperty(subTile3, container, vertical, usedTiles, "", worldRulesOld, worldRulesDynOld, worldRulesDynOldCache)
								if (result == null):
									container.remove(container.size() - 1)
								else:
									usedTiles.append(subTile3)
									usedTiles.append(subTile)
									return grabConditionCheckForAdditional(result, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
							for subTile2 in tiles:
								if (vertical && subTile2.pos == subTile3.pos + Vector2.DOWN || !vertical && subTile2.pos == subTile3.pos + Vector2.RIGHT):
									container.append("not " + subTile3.tileName.split("_")[1])
									var result = grabNoun(subTile2, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, false, usedTiles)
									if (result == null):
										container.remove(container.size() - 1)
										continue
									usedTiles.append(subTile3)
									usedTiles.append(subTile)
									return grabConditionCheckForAdditional(result, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
	return tile

func grabConditionCheckForAdditional(tile, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles) -> Node:
	for andTile in tiles:
		if (vertical && andTile.pos == tile.pos + Vector2.DOWN || !vertical && andTile.pos == tile.pos + Vector2.RIGHT):
			if (andTile.tileType == 5):
				for subTile in tiles:
					if (vertical && subTile.pos == andTile.pos + Vector2.DOWN || !vertical && subTile.pos == andTile.pos + Vector2.RIGHT):
						if (subTile.tileType == 6):
							var result = grabCondition(andTile, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
							if (result != andTile):
								usedTiles.append(andTile)
								return result
						elif (subTile.tileType == 4):
							for subTile2 in tiles:
								if (vertical && subTile2.pos == subTile.pos + Vector2.DOWN || !vertical && subTile2.pos == subTile.pos + Vector2.RIGHT):
									if (subTile2.tileType == 6):
										var result = grabCondition(andTile, container, worldRulesOld, worldRulesDynOld, worldRulesDynOldCache, vertical, usedTiles)
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
				if (tileNum + subpos >= affectedTiles.size() - 1):
					break
				while (affectedTiles[tileNum + subpos + 1] != "on" && affectedTiles[tileNum + subpos +1] != "near" && affectedTiles[tileNum + subpos + 1] != "facing" && affectedTiles[tileNum + subpos + 1] != "not on" && affectedTiles[tileNum + subpos + 1] != "not near" && affectedTiles[tileNum + subpos + 1] != "not facing"):
					condition.append(affectedTiles[tileNum + subpos + 1])
					subpos += 1
					if (tileNum + subpos >= affectedTiles.size() - 1):
						break
				if (tileNum + subpos >= affectedTiles.size() - 1):
					break
			#push_error("condition: " + str(condition))
		
		if "lonely" in affectedTiles[tileNum]:
			ruleDynamic = true
		
		for actionNum in range(0, actions.size()):
			var action = actions[actionNum].split(" ", false)
			if (ruleDynamic):
				var newRule = [affectedTiles[tileNum]]
				if "not " in newRule[0]:
					if (newRule[0] == "not all"):
						continue
					else:
						var notWhat = newRule[0].replace("not " , "")
						for tile in tiles:
							if (tile.tileName == notWhat):
								continue
							if (!dynamicRuleApplyabilityCache.has(tile.tileName)):
								dynamicRuleApplyabilityCache[tile.tileName] = []
							if (!dynamicRuleApplyabilityCache[tile.tileName].has(worldRulesDynamic.size())):
								dynamicRuleApplyabilityCache[tile.tileName].append(worldRulesDynamic.size())
				elif (newRule[0] == "all" || newRule[0] == "level"):
					for tile in tiles:
						if (!dynamicRuleApplyabilityCache.has(tile.tileName)):
							dynamicRuleApplyabilityCache[tile.tileName] = []
						if (!dynamicRuleApplyabilityCache[tile.tileName].has(worldRulesDynamic.size())):
							dynamicRuleApplyabilityCache[tile.tileName].append(worldRulesDynamic.size())
				else:
					if (!dynamicRuleApplyabilityCache.has(newRule[0])):
						dynamicRuleApplyabilityCache[newRule[0]] = []
					dynamicRuleApplyabilityCache[newRule[0]].append(worldRulesDynamic.size())
				for cond in condition:
					newRule.append(cond)
				newRule.append(action[0])
				newRule.append(actions[actionNum].replace(action[0] + " ", ""))
				worldRulesDynamic.append(newRule)
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

func applyRuleInstantly(affectedTile, operator, action, checkAdditional = true, tileInstance = null) -> bool:
	var ifReplacement = false
	var tid
	var not_ = false
	if ("not " in action):
		tid = findTileId("text_" + action.replace("not ", ""))
		not_ = true
	else:
		tid = findTileId("text_" + action)
	if (database.has(tid)):
		ifReplacement = database[tid].type == 0
	if (operator == "is"):
		if (not_):
			return true
		if (ifReplacement):
			if (affectedTile != action):
				if (affectedTile == "text"):
					for subTile in tiles:
						if (tileInstance != null && subTile != tileInstance):
							continue
						if (ifRuleActive(affectedTile, "is", affectedTile, subTile, checkAdditional)):
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
					dynamicRuleApplyabilityCache = {}
				else:
					var running = true
					while running:
						running = false
						for subTile in tiles:
							if (tileInstance != null && subTile != tileInstance):
								continue
							if (subTile.tileName == affectedTile):
								if action == "text":
									changeTileType(subTile, findTileId("text_" + affectedTile))
									subTile.updateSpriteAnim()
								elif (action == "empty"):
									if (destroyTile(subTile, true, false)):
										running = true
								else:
									changeTileType(subTile, findTileId(action))
									subTile.updateSpriteAnim()
		else:
			# probably won't work as I want but ok
			for subTile in tiles:
				if (tileInstance != null && subTile != tileInstance):
					continue
				if (affectedTile == "all" || affectedTile == "level" || subTile.tileName == affectedTile):
					if (action == "you"):
						you_found = true
						if (ifRuleActive(affectedTile, "is", "win", subTile, checkAdditional)):
							controlsActive = false
					elif (action == "win" && ifRuleActive(affectedTile, "is", "you", subTile, checkAdditional)):
						you_found = true
						controlsActive = false
					elif (action == "defeat" && ifRuleActive(affectedTile, "is", "you", subTile, checkAdditional) || action == "you" && ifRuleActive(affectedTile, "is", "defeat", subTile, checkAdditional)):
						destroyTile(subTile)
					elif (action == "hot" && ifRuleActive(affectedTile, "is", "melt", subTile, checkAdditional) || action == "melt" && ifRuleActive(affectedTile, "is", "hot", subTile, checkAdditional)):
						destroyTile(subTile)
					elif (action == "shut" && ifRuleActive(affectedTile, "is", "open", subTile, checkAdditional) || action == "open" && ifRuleActive(affectedTile, "is", "shut", subTile, checkAdditional)):
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

func ifRuleActive(tile_name, operator, action, tile, checkAdditional = true) -> bool:
	return ifRuleActiveRetro(tile_name, operator, action, worldRulesStatic, worldRulesDynamic, dynamicRuleApplyabilityCache, tile, checkAdditional)

func ifRuleActiveRetro(tile_name, operator, action, worldRules, worldRulesDyn, worldRulesDynCache, tile, checkAdditional = true) -> bool:
	return ifRuleActiveRetro_cached(tile_name, operator, action, worldRules, worldRulesDyn, getAppliableRulesStatic(tile_name, worldRules, tile), getAppliableRulesDynamic(tile_name, worldRulesDyn, worldRulesDynCache, tile, checkAdditional))

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
				#push_error(tile_name + ": " + str(worldRules[ruleNoun]))
		else:
			if (ruleNoun == tile_name || ruleNoun == "all" || ruleNoun == "level"):
				appliableRules.append(worldRules[ruleNoun])
				#push_error(tile_name + ": " + str(worldRules[ruleNoun]))
	
	return appliableRules

func getAppliableRulesDynamic(tile_name, worldRulesDyn, applyability, tile, checkAdditional = true) -> Array:
	var appliableRules = []
	
	if tile.tileType != 0:
		tile_name = "text"
	
	if (!applyability.has(tile_name)):
		return appliableRules
	
	for ruleNum in applyability[tile_name]:
		var rule = worldRulesDyn[ruleNum]
		var affectedTile;
		var lonelyType = -1
		if "not lonely " in rule[0]:
			affectedTile = rule[0].replace("not lonely ", "")
			lonelyType = 1
		elif "lonely " in rule[0]:
			affectedTile = rule[0].replace("lonely ", "")
			lonelyType = 0
		if (lonelyType != -1):
			if (!isTileLonely(tile, lonelyType)):
				continue
		var conditionOffset = 1
		var passed = true
		var carriedRule = false
		var conditionText
		while true:
			if (!carriedRule):
				conditionText = rule[conditionOffset]
			var conditionInversed = "not " in conditionText
			if (conditionInversed):
				conditionText = conditionText.replace("not ", "")
			if (conditionText == "on" || conditionText == "near" || conditionText == "facing"):
				lonelyType = -1
				var affectedCollecion = []
				while (conditionOffset + 1 < rule.size() - 2):
					if (rule[conditionOffset + 1] == "on" || rule[conditionOffset + 1] == "near" || rule[conditionOffset + 1] == "facing" || rule[conditionOffset + 1] == "not on" || rule[conditionOffset + 1] == "not near" || rule[conditionOffset + 1] == "not facing"):
						break
					affectedCollecion.append(rule[conditionOffset + 1])
					conditionOffset += 1
				for affectedTile_ in affectedCollecion:
					if "not lonely " in affectedTile_:
						affectedTile = affectedTile_.replace("not lonely ", "")
						lonelyType = 1
					elif "lonely " in affectedTile_:
						affectedTile = affectedTile_.replace("lonely ", "")
						lonelyType = 0
					else:
						affectedTile = affectedTile_
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
				if (!passed):
					break
				conditionOffset += affectedCollecion.size()
			else:
				break
		if (passed):
			var newRule = {}
			newRule[rule[conditionOffset]] = {}
			newRule[rule[conditionOffset]][rule[conditionOffset + 1]] = 1
			appliableRules.append(newRule)
			if (checkAdditional):
				applyRuleInstantly(tile_name, rule[conditionOffset], rule[conditionOffset + 1], false, tile)
	return appliableRules

# stub
func isTileLonely(tile, lonelyType) -> bool:
	return true # todo

func ifOperatorUsed(tile_name, operator, tile) -> String:
	return ifOperatorUsed_cached(tile_name, operator, getAppliableRulesStatic(tile_name, worldRulesStatic, tile), getAppliableRulesDynamic(tile_name, worldRulesDynamic, dynamicRuleApplyabilityCache, tile))

func getRuleStackValue(tile_name, operator, action, tile) -> int:
	return getRuleStackValue_cached(tile_name, operator, action, getAppliableRulesStatic(tile_name, worldRulesStatic, tile), getAppliableRulesDynamic(tile_name, worldRulesDynamic, dynamicRuleApplyabilityCache, tile))

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
	
	for rule in appliableStaticRules:
		if (rule.has(operator) && rule[operator].has(action)):
			for rule in appliableStaticRules:
				if (rule.has(operator) && rule[operator].has("not " + action)):
					return false
			for rule in appliableDynamicRules:
				if (rule.has(operator) && rule[operator].has("not " + action)):
					return false
			return true
	
	for rule in appliableDynamicRules:
		if (rule.has(operator) && rule[operator].has(action)):
			for rule in appliableStaticRules:
				if (rule.has(operator) && rule[operator].has("not " + action)):
					return false
			for rule in appliableDynamicRules:
				if (rule.has(operator) && rule[operator].has("not " + action)):
					return false
			return true
	
	return false

func getRuleStackValue_cached(tile_name, operator, action, appliableStaticRules, appliableDynamicRules) -> int:
	var value = 0

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