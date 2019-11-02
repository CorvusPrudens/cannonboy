extends Node2D

func _ready():
	var polygon = Polygon2D.new()
	polygon.set_name("polygon")
	
	polygon.set_antialiased(true)
	polygon.set_color(Color(0, 0, 0))
	#triangle shape
	
	var arr = [Vector2(global_position.x, global_position.y - 100), 
				Vector2(global_position.x + 50, global_position.y + 50),
				Vector2(global_position.x - 50, global_position.y + 50)]
	polygon.set_polygon(arr)
	add_child(polygon)



func _process(delta):
	var poly = get_node("polygon")
	pass
