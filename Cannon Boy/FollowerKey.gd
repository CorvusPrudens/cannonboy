extends Sprite

var pastPos = []
var go = false
var goTick = 0
var prevPlayerPos
var player
var animationTick = 0
var followOff
var alive: bool = true
var deathTick = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	followOff = get_tree().get_root().get_node("Node2D/FollowKeyContainer").get_child_count()*2
	prevPlayerPos = player.global_position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive:
		if not go:
			prevPlayerPos = player.global_position
			pastPos.push_front(prevPlayerPos)
			goTick += 1
			if goTick > 2 + followOff:
				go = true
		else:
			if abs(prevPlayerPos.x - player.global_position.x) > 3 or abs(prevPlayerPos.y - player.global_position.y) > 2:
				prevPlayerPos = player.global_position
				pastPos.push_front(prevPlayerPos)
				pastPos.pop_back()
		
		if fmod(animationTick, 27) < 9:
			frame = 9 + fmod(animationTick, 9)
		animationTick += 0.4
		
		var target = pastPos[pastPos.size() - 1]
		global_position.x += (target.x - global_position.x)/5
		global_position.y += (target.y - global_position.y)/5
	else:
		deathTick += 1
		if fmod(deathTick, 10) == 0:
			self_modulate = Color(1, 1, 1, (40 - deathTick)/40)
		if deathTick >= 40:
			queue_free()