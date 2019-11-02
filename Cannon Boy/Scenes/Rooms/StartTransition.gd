extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fadeTick: float = 0
var fading: bool = false
var frames = []

func _on_play():
	if not fading:
		frames[0].playing = true
		fading = true

func _on_animation_end():
	if fadeTick < frames.size() - 1:
		frames[fadeTick].visible = false
		fadeTick += 1
		frames[fadeTick].playing = true
	else:
		frames[fadeTick].visible = false
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	set_z_index(100000)
	frames = [$One, $Two, $Three, $Four]
	for frame in frames:
		frame.playing = false
		frame.frame = 0
		frame.flip_v = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if Input.is_action_just_pressed("ui_down"):
	if not fading:
		frames[0].playing = true
		fading = true
