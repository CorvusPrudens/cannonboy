extends Camera2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/Player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position
	pass
