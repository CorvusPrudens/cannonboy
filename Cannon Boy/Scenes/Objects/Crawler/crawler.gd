extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity: Vector2 = Vector2(0, 0)
var alive: bool = true
var moving: bool = false
var moveTick: float = 0
var surfaceNormal: Vector2 = Vector2(-1, 0)
var forward: int = 1
var sprite: Sprite
var selected: bool = false
var selectedTick: float = 0
var deathTick: float = 0
var deathSpeed: Vector2 = Vector2(0, 0)
var part = load("res://Scenes/Objects/Ghost/GhostParticle.tscn")
var turning: bool = false
var decided: bool = false
signal killSS

func _on_turn(body):
	if body == self:
		turning = true

func _on_player_touch(normal, position):
	if normal == surfaceNormal:
		moving = true
		decided = true
		if moveTick == 30:
			moveTick = 0
		if position.y - global_position.y < 0:
			forward = -1
		else:
			forward = 1


func _ready():
	if global_position.x > 25:
		surfaceNormal = Vector2(-1, 0)
	elif global_position.x < -40:
		surfaceNormal = Vector2(1, 0)
	elif global_position.x > 0 and global_position.x < 25:
		surfaceNormal = Vector2(1, 0)
	elif global_position.x < 0 and global_position.x < -40:
		surfaceNormal = Vector2(-1, 0)
	self.connect("killSS", get_tree().get_root().get_node("Node2D/Camera2D"), "_on_killSS")
	for door in get_parent().get_parent().get_node("SideRooms").get_children():
		door.connect("turn", self, "_on_turn")
	get_tree().get_root().get_node("Node2D/Player").connect("onWall", self, "_on_player_touch")
	sprite = $Sprite
	set_z_index(100)
	pass # Replace with function body.


func _physics_process(delta):
	if alive:
		if selected:
			selectedTick += 0.25
			var mod = cos(selectedTick)/2 + 0.5
			set_modulate(Color(1 + mod*4, 1 + mod*4, 1 + mod*4))
		else:
			selectedTick = 0
			set_modulate(Color(1, 1, 1))
		selected = false
		
		move_and_slide(velocity, Vector2(0, -1))
		if get_slide_count() > 0:
			var collision = get_slide_collision(0)
#			surfaceNormal = collision.normal
			if (get_slide_count() > 1 and get_slide_collision(0).normal != get_slide_collision(1).normal) or turning:
				moving = false
				moveTick = 0
				sprite.frame = 0
				velocity = Vector2(0, 0)
				forward *= -1
		
		if moving:
			if not decided:
				sprite.frame = fmod(moveTick/2, 7)
				var a = 10
				moveTick += 1
				if moveTick < 30:
					if surfaceNormal.x != 0:
						
						if surfaceNormal.x < 0:
							velocity.x = 5
							set_global_rotation(-PI/2)
						else:
							velocity.x = -5
							set_global_rotation(PI/2)
						if abs(velocity.y) < 20:
							velocity.y += a*forward
							sprite.flip_h = bool(forward + 1)
					elif surfaceNormal.y == -1:
						velocity.y = 5
						set_global_rotation(0)
						if abs(velocity.x) < 20:
							velocity.x += a*forward
							sprite.flip_h = bool(forward + 1)
					elif surfaceNormal.y == 1:
						velocity.y = -5
						set_global_rotation(0)
						if abs(velocity.x) < 20:
							velocity.x += a*forward
							sprite.flip_h = bool(forward + 1)
				else:
					moving = false
					moveTick = 0
					sprite.frame = 0
			else:
				sprite.frame = fmod(moveTick, 7)
				var a = 25
				moveTick += 1
				if surfaceNormal.x != 0:
					
					if surfaceNormal.x < 0:
						velocity.x = 5
						set_global_rotation(-PI/2)
					else:
						velocity.x = -5
						set_global_rotation(PI/2)
					if abs(velocity.y) < 50:
						velocity.y += a*forward
						sprite.flip_h = bool(forward + 1)
				elif surfaceNormal.y == -1:
					velocity.y = 5
					set_global_rotation(0)
					if abs(velocity.x) < 50:
						velocity.x += a*forward
						sprite.flip_h = bool(forward + 1)
				elif surfaceNormal.y == 1:
					velocity.y = -5
					set_global_rotation(0)
					if abs(velocity.x) < 50:
						velocity.x += a*forward
						sprite.flip_h = bool(forward + 1)
			decided = false
		else:
			velocity.x *= 0.8
			velocity.y *= 0.8
			if abs(velocity.x) < 5:
				velocity.x = 0
			if abs(velocity.y) < 5:
				velocity.y = 0
			if randf() > 0.99:
				moving = true
		
		
		turning = false
	else:
		if deathTick == 0:
			velocity.x += deathSpeed.x/2
			velocity.y += deathSpeed.y/2
			
			emit_signal("killSS")
			
			for i in range(rand_range(5, 9)):
				var particle = part.instance()
				var angle = atan2(deathSpeed.y, deathSpeed.x)
				var mag = sqrt(pow(deathSpeed.x, 2) + pow(deathSpeed.y, 2))/1.7
				
				angle += rand_range(-PI/4, PI/4)
				mag += rand_range(-75, 75)
				particle.velocity.x = cos(angle)*mag
				particle.velocity.y = sin(angle)*mag
				add_child(particle)
		deathTick += 1
		if deathTick < 30:
			sprite.frame = 8 + floor(deathTick/10)
			set_modulate(Color(1, 1, 1, 1 - floor(deathTick/5)/6))
			velocity.x *= 0.93
			velocity.y *= 0.93
			move_and_slide(velocity, Vector2(0, -1))
		else:
			queue_free()
