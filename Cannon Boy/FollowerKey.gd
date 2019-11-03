extends Sprite

var pastPos = []
var go = false
var goTick = 0
var prevPlayerPos
var player
var parent
var animationTick = 0
var followOff
var alive: bool = true
var deathTick = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	parent = get_tree().get_root().get_node("Node2D/FollowKeyContainer")
	followOff = parent.get_child_count()
	prevPlayerPos = player.global_position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if alive:
		
		
		
		if fmod(animationTick, 27) < 9:
			frame = 9 + fmod(animationTick, 9)
		animationTick += 0.4
		
		if followOff == 1:
			var target: Vector2 = Vector2(0, player.global_position.y)
			
			if player.right:
				target.x = player.global_position.x - 11
				flip_h = false
			else:
				target.x = player.global_position.x + 11
				flip_h = true
			
			global_position.x += (target.x - global_position.x)/4
			global_position.y += (target.y - global_position.y)/4
		else:
			if not go:
				var nextKey = parent.get_children()[followOff - 2]
				pastPos.push_front(nextKey.global_position)
				goTick += 1
				if goTick > 2 + followOff:
					go = true
			else:
				var nextKey = parent.get_children()[followOff - 2]
				if sqrt(pow(pastPos[0].x - nextKey.global_position.x, 2) + pow(pastPos[0].y - nextKey.global_position.y, 2)) > 0.5:
					flip_h = nextKey.flip_h
					pastPos.push_front(nextKey.global_position)
					pastPos.pop_back()
					global_position = pastPos[pastPos.size() - 1]
#		var target = pastPos[pastPos.size() - 1]
#		global_position.x += (target.x - global_position.x)/4
#
#		if player.is_on_floor() and global_position.y < player.global_position.y:
#			global_position.y += (player.global_position.y - global_position.y)/5
#			pastPos[pastPos.size() - 1].y = global_position.y
#		else:
#			global_position.y += (target.y - global_position.y)/4
#		print(player.right)
		
	else:
		deathTick += 1
		if fmod(deathTick, 10) == 0:
			self_modulate = Color(1, 1, 1, (40 - deathTick)/40)
		if deathTick >= 40:
			queue_free()