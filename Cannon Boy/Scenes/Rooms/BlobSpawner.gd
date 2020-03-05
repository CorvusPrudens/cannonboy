extends YSort

var gh = load("res://Scenes/Objects/gh/gh.tscn")
var enemyTypes = [load("res://Scenes/Objects/gh/gh.tscn"), load("res://Scenes/Objects/Eyes/eyes.tscn")]
var enemyArr = []
var tiles

func spawnGhosts(num: int, pos: Vector2):
	for i in range(num):
		var index = 0
		var random = randf()
		if random < 0.3:
			index += 1
		var tempBlob = enemyTypes[index].instance()
		add_child(tempBlob)
		var randx
		var randy
		if global_position.y <= -3456:
			randx = rand_range(-80, 80)
			randy = rand_range(50, 192)
			
			while tiles.get_cellv(tiles.world_to_map(Vector2(randx, randy))) != -1:
				randx = rand_range(-80, 80)
				randy = rand_range(50, 192)
		elif global_position.y == 0:
			randx = rand_range(-80, 80)
			randy = rand_range(-192, 0)
			
			while tiles.get_cellv(tiles.world_to_map(Vector2(randx, randy))) != -1:
				randx = rand_range(-80, 80)
				randy = rand_range(-192, 0)
		else:
			randx = rand_range(-80, 80)
			randy = rand_range(-192, 192)
			
			while tiles.get_cellv(tiles.world_to_map(Vector2(randx, randy))) != -1:
				randx = rand_range(-80, 80)
				randy = rand_range(-192, 192)
		
		
		tempBlob.position = Vector2(randx, randy)
		enemyArr.append(tempBlob)

# Called when the node enters the scene tree for the first time.
func _ready():
	tiles = get_parent().get_node("TileMap")
	if get_parent().get_name() != "EndRoom":
		spawnGhosts(5, get_parent().global_position)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
