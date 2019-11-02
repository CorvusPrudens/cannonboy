extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sprite: Sprite
var spriteTick: float = 0
var alive: bool = true

var selected: bool = false
var selectedTick: float = 0

signal end
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("end", get_tree().get_root().get_node("Node2D/Camera2D/EndTransition"), "_on_end")
	self.connect("end", get_tree().get_root().get_node("Node2D/Player"), "_on_end")
	sprite = $Sprite
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spriteTick += 0.23
	sprite.frame = fmod(spriteTick, 12)
	
	if selected:
		selectedTick += 0.2
		set_modulate(Color(1, cos(selectedTick)/2 + 0.5, 1))
	else:
		selectedTick = 0
		set_modulate(Color(1, 1, 1))
	selected = false
	pass


func _on_Area2D_body_entered(body):
	if body == get_tree().get_root().get_node("Node2D/Player"):
		emit_signal("end")
	pass # Replace with function body.
