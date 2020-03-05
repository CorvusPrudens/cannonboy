extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var animationTick = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().get_node("Node2D/LoadScreen").visible = true
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame = animationTick
	if animationTick < 1:
		animationTick += 0.2
	else:
		animationTick += 0.13
	
	if animationTick > 0.6 and animationTick < 1:
		visible = false
	if animationTick >= 1:
		visible = true
	if animationTick >= 1:
		get_tree().get_root().get_node("Node2D/LoadScreen").visible = false
	if animationTick >= 5:
		queue_free()
	pass
