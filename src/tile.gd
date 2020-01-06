extends Sprite

var tileName = ""
var tileType = 0
var direction = 0

var atlasX = 0
var atlasY = 0
var atlasWalkCycle = 0

var atlasCurrentWalkFrame = 0

var oldPos = Vector2(0, 0)
var pos = Vector2(0, 0)
var needsToMove = true

var main;

func updatePos(x, y) -> void:
	var newPos = Vector2(x, y)
	oldPos = pos
	pos = newPos
	needsToMove = true
	if (oldPos != newPos && main.worldLerpTime != 1):
		atlasCurrentWalkFrame += 1
		if (atlasCurrentWalkFrame >= atlasWalkCycle):
			atlasCurrentWalkFrame = 0
	updateSpriteAnim()

func updateSprite(x, y, walkCycle, color) -> void:
	atlasX = x
	atlasY = y
	atlasWalkCycle = walkCycle
	modulate = color
	updateSpriteAnim()
	
func updateSpriteAnim() -> void:
	var xpos = atlasX + direction * atlasWalkCycle + atlasCurrentWalkFrame
	if (direction > 1 && atlasWalkCycle > 1):
		xpos += 1
	region_rect.position.x = xpos * 24
	region_rect.position.y = (atlasY + main.worldAnimationFrame) * 24
	
func toggleCross(enable) -> void:
	pass
	
func _process(delta):
	if (needsToMove):
		position = oldPos.linear_interpolate(pos, main.worldLerpTime) * 24
		if (main.worldLerpTime == 1):
			needsToMove = false