extends Label

var tick = 0
var toggle: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tick += 1
	
	if fmod(tick, 30) == 0:
		if toggle:
			self_modulate = Color(1, 1, 1, 0)
			toggle = false
		else:
			self_modulate= Color(1, 1, 1, 1)
			toggle = true
	pass
