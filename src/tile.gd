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
		direction = 0 if (pos.x == oldPos.x + 1) else 2 if (pos.x == oldPos.x - 1) else 3 if (pos.y == oldPos.y + 1) else 1 if (pos.y == oldPos.y - 1) else direction
	updateSpriteAnim()

func updateSprite(x, y, walkCycle, color) -> void:
	atlasX = x
	atlasY = y
	atlasWalkCycle = walkCycle
	updateSpriteColor(color)
	updateSpriteAnim()

func updateSpriteColor(color) -> void:
	modulate = color

func updateSpriteAnim() -> void:
	var xpos = atlasX + direction * (atlasWalkCycle + (1 if atlasWalkCycle > 1 else 0)) + atlasCurrentWalkFrame + (1 if atlasWalkCycle > 1 else 0)
	region_rect.position.x = xpos * 24
	region_rect.position.y = (atlasY + main.worldAnimationFrame) * 24
	
func toggleCross(enable) -> void:
	pass
	
func _process(delta):
	if (needsToMove):
		position = oldPos.linear_interpolate(pos, main.worldLerpTime) * 24
		if (main.worldLerpTime == 1):
			needsToMove = false
			oldPos = pos