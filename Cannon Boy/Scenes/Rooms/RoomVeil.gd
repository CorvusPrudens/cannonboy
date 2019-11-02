extends Node2D

var leftPoly: Polygon2D
var rightPoly: Polygon2D
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	leftPoly = Polygon2D.new()
	leftPoly.set_color(Color(0, 0, 0))
	var arr = [Vector2(0, 0),
			Vector2(64, 0),
			Vector2(64, -256),
			Vector2(0, -256)]
	leftPoly.set_polygon(arr)
	leftPoly.set_z_index(1000)
	add_child(leftPoly)
	
	rightPoly = Polygon2D.new()
	rightPoly.set_color(Color(0, 0, 0))
	arr = [Vector2(256, 0),
			Vector2(320, 0),
			Vector2(320, -256),
			Vector2(256, -256)]
	rightPoly.set_polygon(arr)
	rightPoly.set_z_index(1000)
	add_child(rightPoly)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent.sideRoom:
		rightPoly.set_color(Color(0, 0, 0, 0))
		leftPoly.set_color(Color(0, 0, 0, 0))
	else:
		rightPoly.set_color(Color(0, 0, 0, 1))
		leftPoly.set_color(Color(0, 0, 0, 1))
	pass
