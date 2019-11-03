extends KinematicBody2D

var left: bool = false
var moving: bool = false
var velocity: Vector2 = Vector2(0, 0)
var moveTick = 0
var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite
	sprite.playing = false
	sprite.frame = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not moving:
		
		moveTick += 1
		if moveTick > 70:
			if randf() > 0.98:
				moving = true
				moveTick = 0
				if randf() > 0.5:
					velocity.x -= 40
					sprite.flip_h = false
				else:
					velocity.x += 40
					sprite.flip_h = true
				velocity.y -= 70
				sprite.playing = true
	
	move_and_slide(velocity, Vector2(0, -1))
	
	velocity.x *= 0.96
	if abs(velocity.x) < 10:
		velocity.x = 0
	if is_on_floor():
		velocity.y = 5
		moving = false
	else:
		velocity.y += 5

func _on_AnimatedSprite_animation_finished():
	sprite.playing = false
	sprite.frame = 0
	pass # Replace with function body.
