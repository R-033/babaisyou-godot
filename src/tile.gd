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
var needsToMove = true

var main;

func updatePos(x, y) -> void:
	var newPos = Vector2(x, y)
	oldPos = pos
	pos = newPos
	needsToMove = true
	if ((tilingMode == 2) != (oldPos == pos) && main.worldLerpTime != 1):
		atlasCurrentWalkFrame += 1
		if (atlasCurrentWalkFrame >= (4 if (tilingMode == 2) else 0)):
			atlasCurrentWalkFrame = 0
		direction = 0 if (pos.x == oldPos.x + 1) else 2 if (pos.x == oldPos.x - 1) else 3 if (pos.y == oldPos.y + 1) else 1 if (pos.y == oldPos.y - 1) else direction
	updateSpriteAnim()

func updateSpriteColor(color) -> void:
	modulate = color

func updateSpriteAnim() -> void:
	var xpos = autoTileValue + direction * ((4 if (tilingMode == 2) else 0)) + atlasCurrentWalkFrame
	texture = main.loadedSprites[tileId][xpos][main.worldAnimationFrame]
	
func toggleCross(enable) -> void:
	pass
	
func _process(delta):
	if (needsToMove):
		position = oldPos.linear_interpolate(pos, main.worldLerpTime) * 24
		if (main.worldLerpTime == 1):
			needsToMove = false
			oldPos = pos