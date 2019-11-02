extends AnimatedSprite

var tick: float = 0
var forward: bool = true
var sf: int = 0
var proceed: bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if (randf() > 0.995):
		proceed = true
	if proceed:
		tick += 240*delta
		if forward:
			if tick >= 3:
				tick = 0
				sf += 1
				if sf < 4:
					set_frame(sf)
				else:
					forward = false
		else:
			if tick >= 3:
				tick = 0
				sf -= 1
				if sf > -1:
					set_frame(sf)
				else:
					forward = true
					proceed = false
	
	if (randf() > 0.995):
		global_position.x = get_parent().global_position.x + randf()*2
		global_position.y = get_parent().global_position.y + randf()*2
