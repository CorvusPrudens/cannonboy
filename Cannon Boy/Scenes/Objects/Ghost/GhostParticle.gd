extends Node2D

var timer: float = 45
var velocity: Vector2 = Vector2(0, 0)
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = round(rand_range(0, 14))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= 1
	if timer > 0:
		global_position.x += velocity.x*delta
		global_position.y += velocity.y*delta
		velocity.x *= 0.92
		velocity.y *= 0.92
		set_modulate(Color(1, 1, 1, floor(timer/15)/3))
	else:
		queue_free()
	pass
