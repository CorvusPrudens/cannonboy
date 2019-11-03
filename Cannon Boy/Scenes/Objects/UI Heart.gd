extends Sprite

var tick = 0
var go: bool = false
var arrive: bool = false
var prevHp = 3
var player
var prevPert = 0
var toggle: bool = false
var red: bool = false
var redTick = 0

var wiggle: bool = false
var wiggleTick = 0

var state

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	if global_position.x == -144:
		state = 1
	elif global_position.x == -128:
		state = 2
	elif global_position.x == -112:
		state = 3
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player.hp < prevHp:
		if state - player.hp == 1:
			go = true
	elif player.hp > prevHp:
		if state - player.hp == 0:
			arrive = true
	prevHp = player.hp
	if go:
		frame = 36 + tick
		tick += 0.2
		if tick > 4:
			go = false 
			tick = 4
	
	if arrive:
		frame = 40 + tick
		tick -= 0.2
		if tick <= 0:
			arrive = false 
			tick = 0
			
	if state - player.hp == 0:
		wiggleTick += 0.13
		if player.hp == 1:
			wiggleTick += 0.13
			if floor(fmod(wiggleTick, 12)) == 0:
				red = true
				prevPert = Vector2((randf() - 0.5)*3, (randf() - 0.5)*3)

			if red:
				if redTick == 0:
					position += prevPert
					player.get_node("Legs").position = prevPert
					player.get_node("Cannon").position = prevPert
					player.set_modulate(Color(0.7, 0.2, 0.2))
				self_modulate = Color(1, 0.3, 0.3)
				redTick += 1
				if redTick > 4:
					position = Vector2(-144, -64)
					player.get_node("Legs").position = Vector2(0, 0)
					player.get_node("Cannon").position = Vector2(0, 0)
					red = false
					redTick = 0
					self_modulate = Color(1, 1, 1)
					player.set_modulate(Color(1, 1, 1))
		if fmod(wiggleTick, 12) < 6:
			frame = 12 + fmod(wiggleTick, 6)
	pass
