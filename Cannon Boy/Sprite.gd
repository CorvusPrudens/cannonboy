extends Sprite

var deathTick: float = 0
var velocity: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	frame = rand_range(0, 15)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deathTick += 1
	if fmod(deathTick, 10) == 0:
		self_modulate = Color(1, 1, 1, (40 - deathTick)/40)
	
	velocity.x *= 0.95
	velocity.y *= 0.95
	
	global_position.x += velocity.x
	global_position.y += velocity.y
	
	if deathTick >= 40:
		queue_free()
	pass
