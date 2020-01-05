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
	updateSpriteAnim()

func updateSprite(x, y, walkCycle, color) -> void:
	atlasX = x
	atlasY = y
	atlasWalkCycle = walkCycle
	#$sprite.modulate = color
	updateSpriteAnim()
	
func updateSpriteAnim() -> void:
	atlasCurrentWalkFrame += 1
	if (atlasCurrentWalkFrame >= atlasWalkCycle):
		atlasCurrentWalkFrame = 0
	texture.region.position.x = (atlasX + direction * atlasWalkCycle + atlasCurrentWalkFrame) * 24
	texture.region.position.y = (atlasY + main.worldAnimationFrame) * 24
	
func toggleCross(enable) -> void:
	pass
	
func _process(delta):
	if (needsToMove):
		$Sprite.position = oldPos.linear_interpolate(pos, main.worldLerpTime) * 24
		if (main.worldLerpTime == 1):
			needsToMove = false