extends Sprite

var player
var go: bool = true
var wait: float = 0
var tick: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame = 24 + fmod(tick, 12)
	tick += 0.2



func _on_Area2D_body_entered(body):
	if body == player:
		queue_free()
	pass # Replace with function body.
