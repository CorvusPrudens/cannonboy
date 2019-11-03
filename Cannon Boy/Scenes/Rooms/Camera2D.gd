extends Camera2D

var vp
var scaling_factor : float = 1
var currentPos = Vector2()
var small : bool = true
var tempFac = scaling_factor
var tempOffset = 48.0
var sideRoom: bool = false
var ss: bool = false
var dss: bool = false
var ssTick: float = 0
var dssTick: float = 0
var ssOffset: Vector2 = Vector2(0, 0)
var player

func _on_killSS():
	ss = true
	ssTick = 0

func _on_damageSS():
	dss = true
	dssTick = 0

func node(string):
	return get_parent().get_node(string)

func set_pos_smooth():
	var target = player.global_position
	if target.x > -96 and target.x < 96:
		currentPos.x = 0
		if player.velocity.y <= 0:
			if tempOffset < 48:
				tempOffset += 1
		elif player.velocity.y == 5:
			if tempOffset < 48:
				tempOffset += 0.5
		elif player.velocity.y >= 100:
			if tempOffset > 0:
				tempOffset -= 1
		if currentPos.y < -3700 and target.y - tempOffset < currentPos.y:
			currentPos.y -= (currentPos.y - target.y + tempOffset)/(8 + abs(currentPos.y + 3700))
		else:
			currentPos.y -= (currentPos.y - target.y + tempOffset)/8
		
		if currentPos.y > 128:
			currentPos.y = 128
		tempFac = 2.0
		sideRoom = false
	elif target.x <= -96:
		currentPos.y = round(target.y/128)*128
		floor(target.y/256)*256
		currentPos.x = -186
		tempFac  = 3.0
		sideRoom = true
	elif target.x >= 96:
		currentPos.y = round(target.y/128)*128
		currentPos.x = 186
		tempFac  = 3.0
		sideRoom = true
	
	var tempPos = currentPos
	
	if ss:
		if ssTick == 0:
			ssOffset = Vector2(0, 0)
		ssTick += 1
		
		if ssTick < 30:
			if fmod(ssTick, 2) == 0:
				ssOffset.x += (randf() - 0.5)*cos((dssTick/30)*(PI/2))*4
				ssOffset.y += (randf() - 0.5)*cos((dssTick/30)*(PI/2))*4
			else:
				ssOffset.x = 0
				ssOffset.y = 0
		else:
			ssTick = 0
			ssOffset = Vector2(0, 0)
			ss = false
	if dss:
		if dssTick == 0:
			ssOffset = Vector2(0, 0)
		dssTick += 1
		
		if dssTick < 40:
			if fmod(dssTick, 2) == 0:
				ssOffset.x += (randf() - 0.5)*cos((dssTick/40)*(PI/2))*6
				ssOffset.y += (randf() - 0.5)*cos((dssTick/40)*(PI/2))*6
			else:
				ssOffset.x = 0
				ssOffset.y = 0
		else:
			dssTick = 0
			ssOffset = Vector2(0, 0)
			dss = false
	
	tempPos.x = round(currentPos.x + ssOffset.x)
	tempPos.y = round(currentPos.y + ssOffset.y)
	$UI.position = Vector2(ssOffset.x, ssOffset.y)
	zoom = Vector2(1/tempFac, 1/tempFac)
	global_position = tempPos
	if global_position.y - 100 < -3840:
		global_position.y = -3840 + 100
	

func _ready():
	player = get_parent().get_node("Player")
	currentPos = player.global_position
	

func _physics_process(delta):
	set_pos_smooth()
		