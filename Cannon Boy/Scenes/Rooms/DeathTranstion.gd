extends Node2D

var fadeTick: float = 0
var fading: bool = false
var frames = []
var end: bool = false
var endTick = 0

func _on_play():
	if not fading:
		frames[0].playing = true
		fading = true

func _on_animation_end():
	if fadeTick < frames.size() - 1:
		fadeTick += 1
		frames[fadeTick].playing = true
	else:
		end = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	set_z_index(100000)
	frames = [$One, $Two, $Three, $Four]
	for frame in frames:
		frame.playing = false
		frame.frame = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fading:
		var vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
		if vol > -60:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol - 0.8)
	if end:
		endTick += 1
		if endTick > 30:
			get_tree().change_scene("res://Scenes/Rooms/Main.tscn")
	if Input.is_action_just_pressed("ui_right"):
		if not fading:
			frames[0].playing = true
			fading = true