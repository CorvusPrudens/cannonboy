extends KinematicBody2D

#need to make it consistent across framerates!!! (maybe it's not very important actually)
var hp = 3
var alive: bool = true
var red: bool = false
var prevPert
var redTick = 0
var damageTaken: bool = false
var damageTick = 0
var targParent: YSort
var targParents = []
var prevLock = null
var bubbleTick = 0
var footTick = 0

var deathTick: float = 0

var partScene = load("res://Scenes/Objects/Particle.tscn")
var partTick: float = 0

var velocity: Vector2 = Vector2(0, 0)
var userInput: bool = false
var floorTick: int = 3
var jumpTick: int = 100
var jumping: bool = true
var preGroundTick: int = 5
var chain: Node2D
var delayTick: int = 1
var landPart: bool = false
var jumpRelease: bool = false
var enemyDead: bool = false

var prevDirRight: bool = false

var targLock: bool = false
var prevTarg
var prevTargPath

var airSpeed: float = 1
var permOffset: float = 0

var releasedJump: bool = false

var wallJumping: bool = false
var wallJumpingTick: float = 0
var wallVector: int = 0
var leaveWallTick: float = 0

var targPoly: Polygon2D
var targLine: Line2D

var cam: Camera2D

var divLines = []

var updateRoom: bool = true
var prevRoomNum: float = 0
var tileParent

var enemyCollision = null

var endSeq: bool = false
var endTick: float = 0
var justLanded: bool = false
var landTick: float = 0

var prevWallLeft: bool = false
var prevWallTick: float = 0
var preWallTick: float = 0
var preWallJumpBool: bool = false

var right: bool = false

var justWall: bool = false
var wallTick: float = 0
var wallStickTick: float = 0

var leftTick: float = 0
var rightTick: float = 0
var waitMoveTick: float = 0

var triggerRelease: bool = true

signal onWall
signal damageSS

var animationTick: float = 0
var deltaOffset = 60


func _on_roomchange():
	updateRoom = true

func _on_body_entered(body):
	if body.get_parent().get_name() == "BlobSpawner":
		enemyCollision = body
	pass 

func _on_end():
	permOffset = velocity.y
	endSeq = true

func _on_death():
	$DeathTranstion.visible = true
	$DeathTranstion._on_play()

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0)
	self.connect("damageSS", get_parent().get_node("Camera2D"), "_on_damageSS")
	get_parent().get_node("RoomSpawner").connect("roomChange", self, "_on_roomchange")
	
	for i in range(5):
		var t = Line2D.new()
		t.add_point(Vector2(0, 0))
		t.add_point(Vector2(0, 0))
		t.set_width(1)
		t.default_color = Color(0, 0, 1)
		divLines.append(t)
		add_child(t)
	cam = get_parent().get_node("Camera2D")
	
	chain = get_parent().get_node("PlayerChain")
	

	set_safe_margin(0.1)

#	targLine = Line2D.new()
#	targLine.add_point(Vector2(0, 0))
#	targLine.add_point(Vector2(0, 0))
#	targLine.set_width(1)
#	targLine.default_color = Color(1, 0, 0)
#	add_child(targLine)


func animation(target):
	animationTick += 1
	$Legs.position.x = 0
	$Cannon.position.x = 0
	if is_on_floor():
		if landPart:
			$SFX.footstep()
			$SFX.chain()
			for i in range(3):
				var particle = partScene.instance()
				particle.velocity = Vector2(rand_range(-0.5, 0), rand_range(-0.5, 0))
				particle.global_position = Vector2(rand_range(global_position.x - 7, global_position.x - 4), global_position.y + 6)
				
				var pp = partScene.instance()
				pp.velocity = Vector2(rand_range(0, 0.5), rand_range(-0.5, 0))
				pp.global_position = Vector2(rand_range(global_position.x  + 4, global_position.x + 7), global_position.y + 6)
				get_parent().add_child(particle)
				get_parent().add_child(pp)
			landPart = false
		else:
			footTick = 0
		if velocity.x > 4:
			$Legs.flip_h = false
			var f = 10 + fmod(animationTick/2, 10)
			$Legs.frame = f
			if f == 11 or f == 16:
				$Cannon.position.y = -1
				$SFX.footstep()
				$SFX.chain()
			else:
				$Cannon.position.y = 0
		elif velocity.x < -4:
			$Legs.flip_h = true
			var f = 10 + fmod(animationTick/2, 10)
			$Legs.frame = f
			if f == 11 or f == 16:
				$Cannon.position.y = -1
				$SFX.footstep()
				$SFX.chain()
			else:
				$Cannon.position.y = 0
		else:
			$Legs.frame = fmod(animationTick/30, 2)
			if fmod((animationTick - 5)/30, 2) >= 1:
				$Cannon.position.y = -1
			else:
				$Cannon.position.y = 0
		if justLanded:
			$Legs.frame = 4
			landTick += 1
			if landTick > 5:
				$Cannon.position.y = 1
			if landTick > 20:
				justLanded = false
				landTick = 0
				animationTick = 0
	if is_on_wall():
		if velocity.x == -5:
			partTick += 1
			if fmod(partTick, 5) == 0:
				var particle = partScene.instance()
				particle.velocity = Vector2(rand_range(-0.3, 0.3), rand_range(-0.5, 0.5))
				particle.global_position = Vector2(global_position.x - 5, global_position.y)
				get_parent().add_child(particle)
			$Legs.flip_h = false
			$Legs.frame = 32
			$Legs.position.x = 2
			$Cannon.position.x = 2
			if justWall:
				wallTick += 1
				$Legs.frame = 31
				$Legs.position.x = 1
				$Cannon.position.x = 1
				if wallTick > 6:
					justWall = false
					wallTick = 0
		elif velocity.x == 5:
			partTick += 1
			if fmod(partTick, 5) == 0:
				var particle = partScene.instance()
				particle.velocity = Vector2(rand_range(-0.3, 0.3), rand_range(-0.5, 0.5))
				particle.global_position = Vector2(global_position.x + 5, global_position.y)
				get_parent().add_child(particle)
			$Legs.flip_h = true
			$Legs.frame = 32
			$Legs.position.x = -2
			$Cannon.position.x = -2
			if justWall:
				wallTick += 1
				$Legs.frame = 31
				$Legs.position.x = -1
				$Cannon.position.x = -1
				if wallTick > 6:
					justWall = false
					wallTick = 0
	else:
		if justWall == false:
			wallTick += 1
			$Legs.frame = 31
			if velocity.x > 0:
				$Legs.position.x = -1
				$Cannon.position.x = -1
				$Legs.flip_h = false
			else:
				$Legs.position.x = 1
				$Cannon.position.x = 1
				$Legs.flip_h = true
			if wallTick > 9:
				justWall = true
				wallTick = 0
		elif velocity.y < -5:
			justLanded = true
			$Cannon.position.y = -1
			$Legs.frame = 2
			if velocity.x < 0:
				$Legs.flip_h = true
			else:
				$Legs.flip_h = false
		elif velocity.y > 5:
			justLanded = true
			$Cannon.position.y = -1
			$Legs.frame = 3
			if velocity.x < 0:
				$Legs.flip_h = true
			else:
				$Legs.flip_h = false
	if not is_on_floor():
		landPart = true
	
	if chain.extended:
		if bubbleTick < 4:
			$Bubble.frame = 0 + bubbleTick
			bubbleTick += 0.20
	else:
		if bubbleTick > 0:
			$Bubble.frame = 0 + bubbleTick
			bubbleTick -= 0.15
		if bubbleTick <= 0:
			$Bubble.frame = 6
	
	var stickAngle = traceStick()
	if stickAngle != null:
		if stickAngle <= 0:
			$Cannon.frame = 20 + ((abs(stickAngle))/PI)*9
	elif is_instance_valid(target):
		$Cannon.frame = 20 + ((abs(atan2(target.global_position.y - global_position.y, target.global_position.x - global_position.x)))/PI)*9

func move(delta, targ):
	if velocity.x > 0:
		right = true
	else:
		right = false
	#gravity
	if is_on_ceiling():
		velocity.y = 0
	
	
	if not is_on_floor():
		if velocity.y < 275:
			if chain.extended:
				velocity.y -= 2
			else:
				velocity.y += 7
		floorTick -= 1
		jumpTick -= 1
		if not is_on_wall() and Input.is_action_just_released("space"):
			jumpRelease = true
		if jumpRelease and Input.is_action_pressed("space"):
			preGroundTick -= 1
		if not userInput or abs(velocity.x) > 110:
			velocity.x *= 0.95
		
		
	else:
		if not Input.is_action_pressed("space"):
			jumpRelease = false
		velocity.y = 5
		floorTick = 5
		jumpTick = 30
		if not Input.is_action_pressed("space"):
			preGroundTick = 6
		jumping = false
		wallJumping = false
		wallJumpingTick = 0
		if not userInput:
			if not damageTaken:
				velocity.x *= 0.5
			elif damageTick < 30:
				velocity.x *= 0.9
		delayTick = 1
		prevWallTick = 0
	
	userInput = false
	
	
	if not damageTaken or damageTick > 30:
	
		if Input.is_action_pressed("left"):
			if is_on_floor():
				if velocity.x > -125:
					velocity.x += clamp(-2.5*leftTick, -33, 0)
					leftTick += 1
					userInput = true
			else:
				if is_on_wall():
					wallStickTick += 1
					if wallStickTick > 9:
						if velocity.x > -110:
							velocity.x -= 15*airSpeed
							userInput = true
				elif chain.extended:
					if velocity.x > -70:
						velocity.x -= 7*airSpeed
						userInput = true
				else:
					if velocity.x > -110:
						velocity.x -= 15*airSpeed
						userInput = true
		else:
			leftTick = 0
	
		if Input.is_action_pressed("right"):
			if is_on_floor():
				if velocity.x < 125:
					velocity.x += clamp(2.5*rightTick, 0, 33)
					rightTick += 1
					userInput = true
			else:
				if is_on_wall():
					wallStickTick += 1
					if wallStickTick > 9:
						if velocity.x < 110:
							velocity.x += 15*airSpeed
							userInput = true
				elif chain.extended:
					if velocity.x < 70:
						velocity.x += 7*airSpeed
						userInput = true
				else:
					if velocity.x < 110:
						velocity.x += 15*airSpeed
						userInput = true
		else:
			rightTick = 0
	
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		wallStickTick = 0

	if (Input.is_action_just_pressed("space") and (is_on_floor() or floorTick > 0)) or (Input.is_action_pressed("space") and is_on_floor() and preGroundTick > 0 and jumpRelease):
		if velocity.y > -150:
			jumpRelease = false
			velocity.y -= 150 + velocity.y
			jumping = true
			$SFX.footstep()
			$SFX.chain()
			preGroundTick = 6
			preWallTick = 6
		for i in range(4):
			var pp = partScene.instance()
			pp.velocity = Vector2((velocity.x + rand_range(-50, 50))/100, (velocity.y + rand_range(-50, 50))/100)
			pp.global_position = Vector2(rand_range(global_position.x  -3, global_position.x + 3), global_position.y + 6)
			get_parent().add_child(pp)
	if Input.is_action_just_released("space") or jumpTick <= 0:
		jumping = false

	if jumping and not wallJumping and Input.is_action_pressed("space") and jumpTick > 0:
		velocity.y -= 4


	airSpeed = 1
	if wallJumping:
		wallJumpingTick += 1
		airSpeed = 0.3 + 0.7*(wallJumpingTick/30)
		if wallJumpingTick > 30:
			wallJumping = false
			wallJumpingTick = 0
	
	var stick = Input.get_joy_axis(0, 7)
#	print(stick)
	if chain.extended:
		var reelSpeed: float
		var maxSpeed: float
		if stick < 0.8:
			reelSpeed = 10
			maxSpeed = 150
		else:
			reelSpeed = 80
			maxSpeed = 200
#		var reelSpeed: float = 80*(0.5 + stick/2)

		var angle: float = atan2(chain.targPos.y - global_position.y, chain.targPos.x - global_position.x)
#		var angle: float = atan2(((chain.vertices[1].global_position.y + chain.vertices[2].global_position.y)/2) - global_position.y,
#								((chain.vertices[1].global_position.x + chain.vertices[2].global_position.x)/2) - global_position.x)
		
#		var angle: float = atan2(chain.vertices[1].global_position.y - global_position.y,
#								chain.vertices[1].global_position.x - global_position.x)
		

		var dist = sqrt(pow(chain.targPos.x - global_position.x, 2) + pow(chain.targPos.y - global_position.y, 2))
#		if sqrt(pow(velocity.x, 2) + pow(clamp(velocity.y, -1000, 0), 2)) < maxSpeed:
		
		if abs(velocity.x) < abs(maxSpeed*cos(angle)):
			velocity.x += (cos(angle)*reelSpeed)
		
		if velocity.y > -abs(maxSpeed*sin(angle)):
			velocity.y += sin(angle)*reelSpeed
		
#		global_position = chain.vertices[0].global_position
		
#		if abs(velocity.x) < maxSpeed:
#			velocity.x += cos(angle)*reelSpeed
#		if abs(velocity.y) < maxSpeed:
#			velocity.y += sin(angle)*reelSpeed
#		if velocity.y > 0:
#			velocity.y *= 0.85

		if is_instance_valid(enemyCollision) and enemyCollision == targ:
			chain.retract(global_position)
			$SFX.shootStop()
			enemyDead = true
#		if abs(global_position.y - chain.targPos.y) <= 20 and abs(global_position.x - chain.targPos.x) <= 20:
#			chain.retract(global_position)
	
	
	move_and_slide(Vector2(velocity.x, velocity.y + permOffset), Vector2(0, -1))
	var collision: KinematicCollision2D
	if get_slide_count() > 0:
		collision = get_slide_collision(0) #this returns the first of an arbitrary order of collisions that occured on the last frame

	if prevWallTick > 0:
		prevWallTick -= 1
	
	if not is_on_floor():
		
		if is_on_wall() and delayTick <= 0:
			
			if collision.get_normal() == Vector2(1, 0):
				emit_signal("onWall", Vector2(1, 0), global_position)
				velocity.x = -5
				if velocity.y < 0:
					velocity.y *= 0.97
				else:
					velocity.y *= 0.84
	
				if Input.is_action_just_pressed("space") or (Input.is_action_pressed("space") and preGroundTick > 0 and jumpRelease):
					
					$SFX.footstep()
					$SFX.chain()
					jumpRelease = false
					preGroundTick = 6
					wallJumping = true
					wallJumpingTick = 0
					wallVector = 1
					
					var tempV: float = 220
					if prevWallLeft:
						tempV -= prevWallTick
						if tempV <= 0:
							tempV = 0
						prevWallTick += 150
					else:
						prevWallTick = 0
					
					prevWallLeft = true
					
					velocity.x += 220*wallVector
					if velocity.y > -220:
						if velocity.y < 0:
							velocity.y -= clamp(tempV + velocity.y, 0, 220)
						else:
							velocity.y = -tempV
					
					prevWallLeft = true
					
					for i in range(4):
						var pp = partScene.instance()
						pp.velocity = Vector2((velocity.x + rand_range(-125, 75))/150, (velocity.y + rand_range(-125, 75))/150)
						pp.global_position = Vector2(global_position.x - 5, rand_range(global_position.y - 2, global_position.y + 2))
						get_parent().add_child(pp)
				delayTick = 1
			elif collision.get_normal() == Vector2(-1, 0):
				emit_signal("onWall", Vector2(-1, 0), global_position)
				velocity.x = 5
				if velocity.y < 0:
					velocity.y *= 0.97
				else:
					velocity.y *= 0.84
	
				if Input.is_action_just_pressed("space") or (Input.is_action_pressed("space") and preGroundTick > 0 and jumpRelease):
					
					$SFX.footstep()
					$SFX.chain()
					jumpRelease = false
					preGroundTick = 6
					wallJumping = true
					wallJumpingTick = 0
					wallVector = -1
					
					var tempV: float = 220
					if not prevWallLeft:
						tempV -= prevWallTick
						if tempV <= 0:
							tempV = 0
						prevWallTick += 150
					else:
						prevWallTick = 0
					
					prevWallLeft = false
	
					velocity.x += 220*wallVector
					if velocity.y > -220:
						if velocity.y < 0:
							velocity.y -= clamp(tempV + velocity.y, 0, 220)
						else:
							velocity.y = -tempV
						
					for i in range(4):
						var pp = partScene.instance()
						pp.velocity = Vector2((velocity.x + rand_range(-125, 75))/150, (velocity.y + rand_range(-125, 75))/150)
						pp.global_position = Vector2(global_position.x + 5, rand_range(global_position.y - 2, global_position.y + 2))
						get_parent().add_child(pp)
				delayTick = 1
		delayTick -= 1

func find_target():
	var targArr = []
	for parents in targParents:
		for children in parents.get_children():
			targArr.append(children)
#	var targArr = targParent.get_children()
	var sortArr = []
	var tempClosest = 10000
	var closestIndex: int = -1
	
	if abs(global_position.x) < 96:
		var vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
		if vol < 0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol + 0.1)
		#sorting time baby
		for targ in targArr:
			var tempDistY = targ.global_position.y - global_position.y
			if tempDistY < -5 and targ.global_position.y > cam.global_position.y - 90 and targ.alive:
				var go: bool = true
				
				#checking for walls between player and potential target
				var tempX = global_position.x
				var tempY = global_position.y
				var angle = atan2(targ.global_position.y - tempY, targ.global_position.x - tempX)
				var tempDiffX = (targ.global_position.x - tempX)/10
				var tempDiffY = (tempDistY)/10
				
				var ref: float = cam.global_position.y - 282
				var num = round(ref/-384)
				if num <= 0:
					num = 0
				
				#ten seems like plenty steps for this
				for i in range(10):
#					var cell = Vector2(floor((tempX + cos(angle)*tempDiff*i)/16)*16, floor((tempY + sin(angle)*tempDiff*i)/16)*16)
					var cell = Vector2(tempX + tempDiffX*i, (tempY + tempDiffY*i) - tileParent.global_position.y)
					if tileParent.get_cellv(tileParent.world_to_map(cell)) != -1:
						go = false
				
				if go:
					var tempAng = abs(angle)
					sortArr.append([targ, pow(targ.global_position.x - global_position.x, 2), pow(tempDistY, 2), tempAng])
		
		var redo: bool = true
		while redo:
			redo = false
			if sortArr.size() > 1:
				for i in range(sortArr.size()):
					if i < sortArr.size() - 1:
						if sortArr[i][1] + sortArr[i][2] > sortArr[i + 1][1] + sortArr[i + 1][2]:
							var tempIndex = sortArr[i + 1]
							sortArr[i + 1] = sortArr[i]
							sortArr[i] = tempIndex
							redo = true
		
		if sortArr.size() > 0:
			if sortArr.size() == 1:
				return(sortArr[0][0])
			else:
				if sqrt(pow(Input.get_joy_axis(0, 3), 2) + pow(Input.get_joy_axis(0, 2), 2)) > 0.5:
					var d = traceStick()
					if d > 0:
						d = d + PI*2
					else:
						d = abs(d)
	#				var dirArr = []
	#				for i in range(sortArr.size()):
	#					dirArr.append([sortArr[i][0], atan2(global_position.y - sortArr[i][0].global_position.y, global_position.x - sortArr[i][0].global_position.x)])
					
					#sorting boogaloo 2, this time by angle
					redo = true
					while redo:
						redo = false
						for i in range(sortArr.size()):
							if i < sortArr.size() - 1:
								if sortArr[i][3] > sortArr[i + 1][3]:
									var tempIndex = sortArr[i + 1]
									sortArr[i + 1] = sortArr[i]
									sortArr[i] = tempIndex
									redo = true
					
					#tossing out enemies that are too close in angle, preferring the closest target (unless too close)
					for i in range(sortArr.size()):
						if i < sortArr.size() - 1:
							#if the angles are too close
							if sortArr[i + 1][3] - sortArr[i][3] < PI/16:
								#find the close one (i is closer in this case)
								if (sortArr[i + 1][1] + sortArr[i + 1][2]) > (sortArr[i][1] + sortArr[i][2]):
									#if i is too close, remove it, otherwise choose the closest one
									if (sqrt(sortArr[i][1] + sortArr[i][2]) < 16):
										sortArr.remove(i)
									else:
										sortArr.remove(i + 1)
		#							i = 0
								else:
									if (sqrt(sortArr[i + 1][1] + sortArr[i + 1][2]) < 16):
										sortArr.remove(i + 1)
									else:
										sortArr.remove(i)
		#							i = 0
					
					if sortArr.size() == 1:
						return sortArr[0][0]
					
					var dividers = []
					for i in range(sortArr.size()):
						if i < sortArr.size() - 1:
							var sdiff: float = PI*2
							var one: float = sortArr[i + 1][3] - sortArr[i][3]
							var two: float = (sortArr[i + 1][3] + PI*2) - sortArr[i][3]
							var three: float = sortArr[i + 1][3] - (sortArr[i][3] + PI*2)
							
							if abs(one) < abs(two):
								sdiff = one
							else:
								sdiff = two
							if abs(three) < abs(sdiff):
								sdiff = three
							
							var barrier: float = (sdiff/2) + sortArr[i][3]
							dividers.append(barrier)
				
					for i in range(sortArr.size()):
						if i == 0:
							if d < dividers[i] and d > 0:
								targLock = true
								prevTarg = sortArr[i][0]
								prevTargPath = prevTarg.get_path()
						if i > 0 and i < sortArr.size() - 1:
							if d < dividers[i] and d > dividers[i - 1]:
								targLock = true
								prevTarg = sortArr[i][0]
								prevTargPath = prevTarg.get_path()
						if i == sortArr.size() - 1:
							if d < PI*1.5 and d > dividers[i - 1]:
								targLock = true
								prevTarg = sortArr[i][0]
								prevTargPath = prevTarg.get_path()
					

			if is_instance_valid(prevTarg) and not prevTarg is KinematicCollision2D:
				if prevTarg.global_position.y < cam.global_position.y - 90 or prevTarg.global_position.y > global_position.y:
					targLock = false
			if not targLock:
				return sortArr[0][0]
			else:
				return prevTarg
	#
		else:
			targLock = false
			return null
	else:
		var vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
		if vol > - 8:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol - 0.1)
		return null

func traceStick():
	if sqrt(pow(Input.get_joy_axis(0, 3), 2) + pow(Input.get_joy_axis(0, 2), 2)) > 0.5:
		var direction = atan2(Input.get_joy_axis(0, 3), Input.get_joy_axis(0, 2))
#		targLine.set_point_position(1, Vector2(cos(direction)*100, sin(direction)*100))
		return direction
	else:
		return null

func _physics_process(delta):
	delta *= deltaOffset
	if alive:
		if hp <= 0:
			alive = false
		#declaring which node holds enemy data
		var ref: float = cam.global_position.y - 282
		var num = round(ref/-384)
		
		if updateRoom or prevRoomNum != num:
			#adding new ones
			var tileNum = num - 1
			if tileNum <= 0:
				tileNum = 0
			tileParent = get_parent().get_node("RoomSpawner").get_node("room" + String(tileNum)).get_node("TileMap")
			
			for child in get_parent().get_node("RoomSpawner").get_children():
				var n = child.get_name()
	#			print(n, "room" + String(num))
				if n == "room" + String(num) or n == "room" + String(num - 1) or n == "room" + String(num + 1):
					targParents.append(child.get_node("BlobSpawner"))
					
				
			#removing old ones
			for i in range(targParents.size() - 1, -1, -1):
				var n = targParents[i].get_parent().get_name()
				if n != "room" + String(num) and n != "room" + String(num + 1) and n != "room" + String(num - 1):
					targParents.remove(i)
			updateRoom = false
			
			
			#removing duplicates cause im so lazy lol
			for i in range(targParents.size() - 1, -1, -1):
				for j in range(targParents.size()):
					if i != j and targParents[i] == targParents[j]:
						targParents.remove(j)
						break
	
		prevRoomNum = num
		
		var targ = find_target()
		if is_instance_valid(targ):
			targ.selected = true
		move(delta, targ)
		if Input.get_joy_axis(0, 7) < 0.1:
			triggerRelease = true
			prevLock = null
		
		if (Input.get_joy_axis(0, 7) > 0.1 and triggerRelease) or Input.is_action_just_pressed("shift"):
			if chain.retracted and is_instance_valid(targ):
				chain.extend(targ)
				$SFX.shoot()
				prevLock = targ
				prevWallTick = 0
				triggerRelease = false
		if (Input.get_joy_axis(0, 7) < 0.1 or global_position.y < chain.targPos.y - 5) and chain.extended:
			chain.retract(global_position)
		chain.chainUpdate(delta)
#		if hp == 1:
#			if randf() > 0.98:
#				red = true
#				prevPert = Vector2((randf() - 0.5)*4, (randf() - 0.5)*4)
#
#			if red:
#				if redTick == 0:
#					$Legs.position = prevPert
#					$Cannon.position = prevPert
#				set_modulate(Color(1, 0.5, 0.5))
#				redTick += 1
#				if redTick > 3:
#					$Legs.position = Vector2(0, 0)
#					$Cannon.position = Vector2(0, 0)
#					red = false
#					redTick = 0
#					set_modulate(Color(1, 1, 1))
		
		if damageTaken and hp != 0:
			damageTick += 1
			set_modulate(Color(1, 1, 1, (fmod(damageTick/2, 2)/1.5) + 0.33))
			if damageTick > 60:
				set_modulate(Color(1, 1, 1, 1))
				damageTaken = false
				damageTick = 0
		animation(targ)
		if is_instance_valid(enemyCollision):
			if enemyCollision == prevLock or bubbleTick > 0:
				$SFX.kill()
				enemyCollision.alive = false
				enemyCollision.deathSpeed = velocity
				if cam.get_node("KeyContain/KeyBar").rect_size.x < 27:
					cam.get_node("KeyContain/KeyBar").rect_size.x += 5
				
				if cam.get_node("KeyContain/KeyBar").rect_size.x >= 30:
					cam.get_node("UI/Key").keyGet = true
					print("sent")
				if is_instance_valid(targ) and enemyCollision == targ:
					chain.retract(global_position)
					$SFX.shootStop()
					enemyDead = true
			elif not chain.extended and not damageTaken and bubbleTick <= 0 and enemyCollision.alive:
				emit_signal("damageSS")
				
				for i in range(7):
					var particle = partScene.instance()
					particle.velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))
					particle.global_position = Vector2(global_position.x, global_position.y)
					get_parent().add_child(particle)
				
				var angle = atan2(global_position.y - enemyCollision.global_position.y, global_position.x - enemyCollision.global_position.x)
				if abs(velocity.x) < 300:
					velocity.x = cos(angle)*300
				if abs(velocity.y) < 300:
					velocity.x = sin(angle)*300
#				hp -= 1
				$SFX.damage()
				damageTaken = true
		enemyCollision = null
		enemyDead = false
		
#		if endSeq:
#			endTick += 1
#			if endTick > 60:
##				get_tree().quit()
##				var scene = load("res://Scenes/Rooms/Main.tscn")
#				get_tree().change_scene("res://Scenes/Rooms/Main.tscn")
	else:
		
		chain.visible = false
		$Cannon.self_modulate = Color(1, 1, 1, (4 - deathTick)/4)
		deathTick += 0.1
		move_and_slide(velocity)
		velocity *= 0.95
		if deathTick < 4:
			$Legs.frame = 4 + deathTick
		if deathTick > 4:
			
#			visible = false
			$Legs.visible = false
			$Cannon.visible = false
			$Bubble.visible = false
			
		if deathTick > 12:
			$DeathTranstion.visible = true
			$DeathTranstion._on_play()

