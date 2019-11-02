extends KinematicBody2D

var moveTick: int = 0
var moveDur: int = 0
var right: bool = false
var up: bool = true
var decided: bool = false
var moving: bool = true
var yAccel: float = 0
var normal: bool = true
var speed: Vector2 = Vector2(0, 0)
var sprite: Sprite
var alive: bool = true
var deathSpeed: Vector2 = Vector2(0, 0)
var deathTick: float = 0
var part = load("res://Scenes/Objects/Ghost/GhostParticle.tscn")
var cam
var selected: bool = false
var selectedTick: float = 0

signal killSS

# Called when the node enters the scene tree for the first time.
func _ready():
	set_z_index(100)
	for door in get_parent().get_parent().get_node("SideRooms").get_children():
		door.connect("turn", self, "_on_turn")
	sprite = get_node("Sprite")
	if randf() > 0.5:
		right = true
	self.connect("killSS", get_tree().get_root().get_node("Node2D/Camera2D"), "_on_killSS")

func _on_selected():
	selected = true

func _on_turn(body):
	if body == self:
		moveDur = 0
		speed = Vector2(0, 0)
		sprite.frame = 0
		moving = false
		decided = true
		normal = true
		if right:
			right = false
		else:
			right = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive:
		if selected:
			selectedTick += 0.25
			var mod = cos(selectedTick)/2 + 0.5
			set_modulate(Color(1 + mod*4, 1 + mod*4, 1 + mod*4))
		else:
			selectedTick = 0
			set_modulate(Color(1, 1, 1))
		selected = false
		if not moving:
			moveTick += 1
			if normal:
				if fmod(moveTick, 50) < 25:
					sprite.frame = 0
				else:
					sprite.frame = 10
			if randf() > 0.995:
				normal = false
				sprite.frame = rand_range(4, 10)
			if moveTick > 60:
				if randf() > 0.95:
					moving = true
					moveTick = 0
					if not decided:
						if randf() > 0.5:
							right = true
						else:
							right = false
						
						if randf() > 0.5:
							yAccel = (randf() - 1)/4
						else:
							yAccel = randf()/4
		
		if moving:
			moveDur += 1
			if moveDur < 100:
				if right:
					sprite.flip_h = false
					if abs(speed.x) + abs(speed.y) < 30:
						speed.x += 0.5
						speed.y += yAccel
					if speed.x < 10:
						sprite.frame = 0
					elif speed.x >= 10 and speed.x < 20:
						sprite.frame = 1
					else:
						sprite.frame = 2
				else:
					sprite.flip_h = true
					if abs(speed.x) + abs(speed.y) < 30:
						speed.x -= 0.5
						speed.y += yAccel
					if speed.x > -10:
						sprite.frame = 0
					elif speed.x >= -10 and speed.x > -20:
						sprite.frame = 1
					else:
						sprite.frame = 2
			else:
				speed.x *= 0.95
				speed.y *= 0.95
				
				if right:
					sprite.flip_h = false
					if speed.x < 10:
						sprite.frame = 0
					elif speed.x >= 10 and speed.x < 20:
						sprite.frame = 1
					else:
						sprite.frame = 2
				else:
					sprite.flip_h = true
					if speed.x > -10:
						sprite.frame = 0
					elif speed.x >= -10 and speed.x > -20:
						sprite.frame = 1
					else:
						sprite.frame = 2
				
				if abs(speed.x) + abs(speed.y) < 1:
					moving = false
					moveDur = 0
					decided = false
					normal = true
		
		move_and_slide(speed, Vector2(0, -1))
		if get_slide_count() > 0:
			var collision = get_slide_collision(0)
			if collision.normal == Vector2(1, 0):
				right = true
				global_position.x += 1
			elif collision.normal == Vector2(-1, 0):
				right = false
				global_position.x -= 1
			elif collision.normal == Vector2(0, -1):
				yAccel = (randf() - 1)/4
				global_position.y -= 1
			elif collision.normal == Vector2(0, 1):
				yAccel = (randf())/4
				global_position.y += 1
			moveDur = 0
			speed = Vector2(0, 0)
			sprite.frame = 0
			moving = false
			decided = true
			normal = true
	else:
		if deathTick == 0:
			speed.x += deathSpeed.x/2
			speed.y += deathSpeed.y/2
			
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
			sprite.frame = 12 + floor(deathTick/10)
			set_modulate(Color(1, 1, 1, 1 - floor(deathTick/5)/6))
			speed.x *= 0.93
			speed.y *= 0.93
			move_and_slide(speed, Vector2(0, -1))
		else:
			queue_free()
	pass
