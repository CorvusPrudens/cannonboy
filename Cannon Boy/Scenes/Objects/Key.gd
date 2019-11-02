extends Sprite

var go: bool = true
var tick = 0
var watTick = 0
var keyGet: bool = false
var keyTick = 0
var boxTick = 0
var box
var follow = load("res://Scenes/Objects/FollowerKey.tscn")
var followOff = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	box = get_parent().get_parent().get_node("KeyContain/KeyBar")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	boxTick += 0.5
	if fmod(boxTick, 10) == 0 :
		if box.rect_size.x > 0:
			box.rect_size.x -= 1

	if not keyGet:
		if go:
			frame = 0 + tick
			tick += 0.3
			if tick > 9:
				tick = 0
				go = false
		else:
			watTick += 1
			if watTick > 120:
				go = true
				watTick = 0
	else:
		box.rect_size.x = 0
		
		frame = 9 + keyTick
		keyTick += 0.3
		if keyTick > 9:
			keyGet = false
			keyTick = 0
			keyGet = false
			var fol = follow.instance()
			get_tree().get_root().get_node("Node2D/FollowKeyContainer").add_child(fol)
