extends Node2D

class Vertex:
	extends Node2D
	
	var prevPos: Vector2
	var sprite: Sprite
	var sp = load("res://Scenes/Objects/Link.tscn")
	
	var g
	var ground
	var groundBounce
	var drag
	var pos
	
	var start: bool = true
	
	func _init(pos, _g=0.4, _ground=180, _groundBounce=1, _drag=0.98):
		sprite = sp.instance()
		sprite.frame = round(rand_range(0, 3))
		sprite.set_z_index(10)
		add_child(sprite)
		self.pos = pos
#		self.global_position = pos
#		self.prevPos = self.global_position
		
		self.g = _g
		self.ground = _ground
		self.groundBounce = _groundBounce
		self.drag = _drag
	
	func update():
		if start:
			start = false
			self.global_position = self.pos
			self.prevPos = self.global_position
		var dx = (self.global_position.x - self.prevPos.x)*self.drag
		var dy = (self.global_position.y - self.prevPos.y)*self.drag
		self.prevPos = global_position
		global_position.x += dx
		global_position.y += dy
		global_position.y += g
		
		if global_position.y > ground:
			dx = (self.global_position.x - self.prevPos.x)*self.drag
			dy = (self.global_position.y - self.prevPos.y)*self.drag
			var speed = sqrt((dx*dx)+(dy*dy))
			global_position.y = ground
			prevPos.y = ground + dy*groundBounce
			prevPos.x += (dy/speed)*dx

class Chain:
	extends Node2D
	
	var vertices = []
	var lines = []
	
	func _init():
#		print(self.global_position)
		pass
	
	func addVertices(vNum):
		for i in range(vNum):
			var l = Vertex.new(self.global_position)
			vertices.append(l)
			add_child(l)
	
	func addVertex(pos):
		var l = Vertex.new(pos)
		vertices.append(l)
		add_child(l)
	
	func addLine(lineArr):
		self.lines.append(lineArr)
			
	func constrainLines(stiffness: int=1):
		for i in range(stiffness):
			for line in self.lines:
				var p1 = self.vertices[line[0]]
				var p2 = self.vertices[line[1]]
				
				var dx = p2.global_position.x - p1.global_position.x
				var dy = p2.global_position.y - p1.global_position.y
				var dist = sqrt(dx*dx+dy*dy)
				
				var frac = ((line[2] - dist)/dist)/2
				
				dx *= frac
				dy *= frac
				p1.global_position.x -= dx
				p1.global_position.y -= dy
				
				p2.global_position.x += dx
				p2.global_position.y += dy
	
	func update():
		for vertex in self.vertices:
			vertex.update()
	
	
	
	
	
	

var chain
var cam
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_parent().get_node("Camera2D")
	player = get_parent().get_node("Player")
	chain = Chain.new()
#	chain.global_position = global_position
	add_child(chain)
	for i in range(10):
		chain.addVertex(Vector2(-30 + i*6, 80))
	for i in range(9):
		chain.addLine([i, i + 1, 10])
#	chain.addVertex(Vector2(0, 60))
#	chain.addVertex(Vector2(20, 80))
#	chain.addLine([0, 1, 50])
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chain.update()
	chain.constrainLines(5)
	var mousePos = get_viewport().get_mouse_position()/2  - Vector2(160, 90)
	if mousePos.y < 40:
		cam 
		chain.vertices[0].global_position = cam.global_position + mousePos
	chain.vertices[chain.vertices.size() - 1].global_position = player.global_position
	pass
