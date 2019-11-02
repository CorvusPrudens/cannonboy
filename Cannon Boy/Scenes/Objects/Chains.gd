extends AudioStreamPlayer

export(Array, AudioStream) var streams

var play: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	for
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if play:
		stream = streams[rand_range(0, streams.size())]
		play()
		play = false
	pass