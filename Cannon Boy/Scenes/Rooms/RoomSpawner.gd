extends Node2D

signal roomChange
var cam: Camera2D
export(Array, PackedScene) var rooms 

#= [load("res://Scenes/Rooms/TallRoom.tscn"), 
#			load("res://Scenes/Rooms/Left Room.tscn"), 
#			load("res://Scenes/Rooms/Right Room.tscn"),
#			load("res://Scenes/Rooms/MidRoom.tscn")]
var endRoom = load("res://Scenes/Rooms/EndRoom.tscn")
var roomArr = []
var prevVal: float = 0
var player
var prevRoomNum = 0
var endRoomGenerated: bool = false

var taken = [false, false, false, false, false, false, false, false]

var generatedRooms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	prevRoomNum = floor(rand_range(0, rooms.size()))
	player = get_parent().get_node("Player")
	for i in range(10):
		generatedRooms.append(false)
	generatedRooms[0] = true
	cam = get_parent().get_node("Camera2D")
	pass # Replace with function body.


func _process(delta):
	
	if abs(player.global_position.x) < 79:
		var ref: float = cam.global_position.y - 282
		var num = round(ref/-384) 
		if num != prevVal and num < 9 and generatedRooms[num] == false:
			var rando = floor(rand_range(0, rooms.size()))
			#ensures a room isn't generated twice in a row
			while taken[rando]:
				rando = floor(rand_range(0, rooms.size()))
			taken[rando] = true
			print(rando)
			prevRoomNum = rando
			var tempRoom = rooms[rando].instance()
			tempRoom.global_position = Vector2(0, -384*num)
			tempRoom.set_name("room" + String(num))
			roomArr.append(tempRoom)
			add_child(tempRoom)
			generatedRooms[num] = true
			emit_signal("roomChange")
		elif num != prevVal and num == 9 and not endRoomGenerated:
			var tempRoom = endRoom.instance()
			tempRoom.global_position = Vector2(0, -384*num)
			tempRoom.set_name("room" + String(num))
			roomArr.append(tempRoom)
			add_child(tempRoom)
			emit_signal("roomChange")
			endRoomGenerated = true
		prevVal = num
