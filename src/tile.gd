extends Sprite

var tileName = ""
var tileId = ""
var tileType = 0
var direction = 0
var autoTileValue = 0
var isFloating = false
var isSleeping = false

var atlasCurrentWalkFrame = 0

var tilingMode = -1

var oldPos = Vector2(0, 0)
var pos = Vector2(0, 0)

var main;

var needsToMoved = false

func updatePos(x, y) -> void:
	var newPos = Vector2(x, y)
	oldPos = pos
	pos = newPos
	needsToMoved = true
	if ((tilingMode == 2 || tilingMode == 3 || tilingMode == 0) != (oldPos == pos) && main.worldLerpTime != 1):
		var oldDir = direction
		direction = 0 if (pos.x == oldPos.x + 1) else 2 if (pos.x == oldPos.x - 1) else 3 if (pos.y == oldPos.y + 1) else 1 if (pos.y == oldPos.y - 1) else -1
		if (direction == -1):
			direction = oldDir
		elif (tilingMode != 3):
			updateWalkFrame()
	updateSpriteAnim()

func updateWalkFrame() -> void:
	atlasCurrentWalkFrame += 1
	if (atlasCurrentWalkFrame >= (4 if (tilingMode == 2 || tilingMode == 3) else 0)):
		atlasCurrentWalkFrame = 0

func updateSpriteColor(color) -> void:
	modulate = color

func updateSpriteAnim() -> void:
	var xpos;
	if (tilingMode == 1):
		xpos = autoTileValue
	elif (tilingMode == 2):
		if (isSleeping):
			xpos = 16 + direction
		else:
			xpos = direction * 4 + atlasCurrentWalkFrame
	elif (tilingMode == 3):
		xpos = direction * 4 + atlasCurrentWalkFrame
	elif (tilingMode == 0):
		xpos = direction
	else:
		xpos = 0
	texture = main.loadedSprites[tileId][xpos][main.worldAnimationFrame]
	
func toggleCross(enable) -> void:
	pass
	
func _process(delta):
	if (needsToMoved || isFloating):
		position = position.linear_interpolate(pos * 24, min(1, delta * 10))
		offset.y = (-6 + sin(main.curTime / 200.0) * 3) if isFloating else 0
		if (position.distance_to(pos * 24) < 0.01):
			position = pos * 24
			needsToMoved = false