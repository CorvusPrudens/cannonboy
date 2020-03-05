extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fadeTick: float = 0
var fading: bool = false
var frames = []
var end = false
var endTick = 0
var ready: bool = false
var readyTick = 0

func _on_end():
	ready = true
		

func _on_animation_end():
	if fadeTick < frames.size() - 1:
		fadeTick += 1
		frames[fadeTick].playing = true
	else:
		end = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	set_z_index(1024)
	frames = [$One, $Two, $Three, $Four]
	for frame in frames:
		frame.playing = false
		frame.frame = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ready:
		readyTick += 1
		if readyTick == 20:
				get_tree().get_root().get_node("Node2D/Player/SFX").stinger3()
		if readyTick > 60:
			visible = true
			frames[0].playing = true
			fading = true
			
			
	if fading:
		var vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
		if vol > -60:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol - 0.2)
#	if Input.is_action_just_pressed("ui_up"):
#		if not fading:
#			visible = true
#			frames[0].playing = true
#			fading = true
	if end:
		endTick += 1
		if endTick == 30:
			get_tree().get_root().get_node("Node2D/LoadScreen").visible = true
		elif endTick > 32:
			get_tree().change_scene("res://Scenes/Rooms/Main.tscn")
	pass
