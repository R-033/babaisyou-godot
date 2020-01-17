extends Sprite

var tileName = ""
var tileId = ""
var tileType = 0
var direction = 0
var autoTileValue = 0

var atlasCurrentWalkFrame = 0

var tilingMode = -1

var oldPos = Vector2(0, 0)
var pos = Vector2(0, 0)

var main;

func updatePos(x, y) -> void:
	var newPos = Vector2(x, y)
	oldPos = pos
	pos = newPos
	if ((tilingMode == 2 || tilingMode == 3) != (oldPos == pos) && main.worldLerpTime != 1):
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
	var xpos = autoTileValue + direction * ((4 if (tilingMode == 2 || tilingMode == 3) else 0)) + atlasCurrentWalkFrame
	texture = main.loadedSprites[tileId][xpos][main.worldAnimationFrame]
	
func toggleCross(enable) -> void:
	pass
	
func _process(delta):
	position = position.linear_interpolate(pos * 24, delta * 10)