extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Upwell_body_entered(body):
	var player = get_tree().get_root().get_node("Node2D/Player")
	if body == player:
		player.upwell = true
	pass # Replace with function body.



func _on_Upwell_body_exited(body):
	var player = get_tree().get_root().get_node("Node2D/Player")
	if body == player:
		player.upwell = false
	pass # Replace with function body.
