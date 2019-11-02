extends Sprite

var legs

# Called when the node enters the scene tree for the first time.
func _ready():
	legs =  get_parent().get_node("Legs")
	pass # Replace with function body.

func _process(delta):
#	if (legs.frame == 1 or legs.frame == 11 or legs.frame == 16):
#		position.y = -1
#	else:
#		position.y = 0
	pass
