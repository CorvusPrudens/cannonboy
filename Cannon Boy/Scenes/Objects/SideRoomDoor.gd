extends Node2D

var sprite
var overlay
var play = false
var tick = 0
var player
var toggle = true
var count = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal turn
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	sprite = $Sprite
	overlay = $Overlay
	if global_position.x > 0:
		sprite.flip_h = true
		overlay.flip_h = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if play:
		if tick < 6:
			sprite.frame = tick
			tick += 0.4
		elif tick < 12:
			sprite.frame = 11
			overlay.visible = true
			overlay.frame = tick
			tick += 0.4
			if tick > 8 and toggle:
				toggle = false
				$KinematicBody2D.add_collision_exception_with(player)
				get_tree().get_root().get_node("Node2D/FollowKeyContainer").get_children()[count - 1].queue_free()
	if abs(player.global_position.x) > 96:
		overlay.set_z_index(1)
	else:
		overlay.set_z_index(1000)


func _on_Area2D_body_entered(body):
	emit_signal("turn", body)



func _on_Area2D2_body_entered(body):
	count = get_tree().get_root().get_node("Node2D/FollowKeyContainer").get_child_count()
	if body == player and count > 0:
		play = true
		$SFX.playing = true
	pass 
