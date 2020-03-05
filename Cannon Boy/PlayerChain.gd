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
	
	func _init(pos, _g=0.4, _ground=250, _groundBounce=1, _drag=0.98):
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

var player
var startPos: Vector2
var endPos: Vector2
var targPos: Vector2
var targInst
var linkVal: int
var sprite: Sprite
var sp = load("res://Scenes/Objects/Hook.tscn")
var links = []

#extension logic
var extend: bool = false
var extending: bool = false
var extended: bool = false
var extSpeed: float = 20

#retraction logic
var retract: bool = false
var retracting: bool = false
var retracted: bool = true
var retractSpeed: float = 40

var segLength: float = 3

var vertices = []
var lines = []

func addVertices(vNum):
	for i in range(vNum):
		var l = Vertex.new(self.global_position)
		vertices.append(l)
		add_child(l)

func addVertex(pos):
	var l = Vertex.new(pos)
	vertices.append(l)
	add_child(l)

func pushVertex(pos):
	var l = Vertex.new(pos)
	vertices.push_front(l)
	add_child(l)

func popVertex():
	vertices[0].queue_free()
	vertices.pop_front()

func pushLine():
	pushVertex(player.global_position)
	for line in self.lines:
		line[0] += 1
		line[1] += 1
	lines.push_front([0, 1])

func popLine():
	popVertex()
	lines.pop_back()

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
			
			if dist == 0:
				dist = 0.000001
			var frac = ((segLength- dist)/dist)/2
			
			dx *= frac
			dy *= frac
			p1.global_position.x -= dx
			p1.global_position.y -= dy
			
			p2.global_position.x += dx
			p2.global_position.y += dy

func extend(t):
	if not self.extending:
		self.extend = true
		self.targPos = t.global_position
		self.targInst = t

func retract(tp: Vector2):
	if not self.retracting:
		self.retract = true
		self.targPos = tp

func chainUpdate(d):
	if self.extend:
		self.extending = true
		self.retracted = false

		var angle: float = atan2(self.targPos.y - self.endPos.y, self.targPos.x - self.endPos.x)

		self.endPos.x += cos(angle)*self.extSpeed
		self.endPos.y += sin(angle)*self.extSpeed

		if abs(self.endPos.y - self.targPos.y) <= self.extSpeed and abs(self.endPos.x - self.targPos.x) <= self.extSpeed:
			self.endPos = self.targPos
			self.extend = false
			self.extending = false
			self.extended = true

	if self.retract:
		self.retracting = true
		self.extended = false
		var angle: float = atan2(self.targPos.y - self.endPos.y, self.targPos.x - self.endPos.x)

		self.endPos.x += cos(angle)*self.extSpeed
		self.endPos.y += sin(angle)*self.extSpeed

		if abs(self.endPos.y - self.targPos.y) <= self.extSpeed and abs(self.endPos.x - self.targPos.x) <= self.extSpeed:
			self.endPos = self.targPos
			self.retract = false
			self.retracting = false
			self.retracted = true

	if self.retracted or self.retracting:
		self.endPos = player.global_position
#			self.endPos = Vector2(0, 100)
	
	if self.retracted:
		self.segLength = 3
	
	if self.extended or self.extending:
		segLength = 10
	
	var stretchDist = sqrt(pow(vertices[0].global_position.x - vertices[1].global_position.x, 2) + pow(vertices[0].global_position.x - vertices[1].global_position.y, 2))
	var dist = sqrt(pow(player.global_position.x - vertices[1].global_position.x, 2) + pow(player.global_position.y - vertices[1].global_position.y, 2))
	if self.extending or (self.extended and lines.size() < 9):
		if dist > 12:
			pushLine()
		elif dist <= 12 and lines.size() > 3:
			popLine()
	
	
	if self.retracting or (self.retracted and lines.size() > 3):
		if dist <= 10 and lines.size() > 3:
			popLine()
		
	
	if self.extended:
		for vertex in vertices:
			vertex.drag = 0.6
		if lines.size() < 9:
			if dist > 12:
				pushLine()
		elif (dist <= 10 or vertices[1].global_position.y - player.global_position.y > 0) and lines.size() > 3:
			popLine()
		if is_instance_valid(self.targInst):
			self.endPos = self.targInst.global_position
			self.targPos = self.targInst.global_position
	else:
		for vertex in vertices:
			vertex.drag = 0.98
	
	for vertex in self.vertices:
		vertex.update()
	
	self.constrainLines(5)

func _ready():
	player = get_parent().get_node("Player")
	sprite = sp.instance()
	sprite.set_z_index(1)
	sprite.global_position = global_position
	add_child(sprite)
	
	for i in range(3):
		addVertex(Vector2(-30 + i*12, 250))
	for i in range(2):
		addLine([i, i + 1, 10])
	pass
	
func _process(delta):
	startPos = player.global_position
	vertices[0].global_position = startPos
	
	vertices[vertices.size() - 1].global_position = endPos
	sprite.global_position = endPos