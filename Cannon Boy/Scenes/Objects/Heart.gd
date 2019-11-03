extends Sprite

var player
var go: bool = true
var wait: float = 0
var tick: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	if randf() > 0.5:
		queue_free()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if go:
		frame = 12 + tick
		tick += 0.2
		if tick >= 10:
			frame = 12
			go = false
			tick = 0
	else:
		wait += 1
		if wait > 30:
			go = true
			wait = 0


func _on_Area2D_body_entered(body):
	if body == player:
		player.hp += 1
		player.get_node("SFX").itemGet()
		queue_free()
	pass # Replace with function body.
