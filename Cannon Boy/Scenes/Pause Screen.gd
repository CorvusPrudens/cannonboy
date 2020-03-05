extends Node2D

var paused: bool = false
var pos = 0
var pauseTick = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		if paused:
			paused = false
			visible = false
			get_tree().paused = false
			$MenuEnter.play(0)
		else:
			paused = true
			visible = true
			get_tree().paused = true
			$MenuSound.play(0)
			pauseTick = 0
	if paused:
		pauseTick += 0.1
		if Input.is_action_just_pressed("up"):
			pos -= 1
			if pos < 0:
				pos = 2
			$MenuSound.play(0)
		elif Input.is_action_just_pressed("down"):
			pos += 1
			if pos > 2:
				pos = 0
			$MenuSound.play(0)
		
		if pos == 0:
			$Resume.self_modulate = Color((cos(pauseTick) + 1)/2, (cos(pauseTick) + 1)/2, 1)
			$Reload.self_modulate = Color(1, 1, 1)
			$Quit.self_modulate = Color(1, 1, 1)
			if Input.is_action_just_pressed("space"):
				paused = false
				visible = false
				get_tree().paused = false
				$MenuEnter.play(0)
		elif pos == 1:
			$Resume.self_modulate = Color(1, 1, 1)
			$Reload.self_modulate = Color((cos(pauseTick) + 1)/2, (cos(pauseTick) + 1)/2, 1)
			$Quit.self_modulate = Color(1, 1, 1)
			if Input.is_action_just_pressed("space"):
				paused = false
				visible = false
				get_tree().paused = false
				get_tree().change_scene("res://Scenes/Rooms/Main.tscn")
				$MenuEnter.play(0)
		elif pos == 2:
			$Resume.self_modulate = Color(1, 1, 1)
			$Reload.self_modulate = Color(1, 1, 1)
			$Quit.self_modulate = Color((cos(pauseTick) + 1)/2, (cos(pauseTick) + 1)/2, 1)
			if Input.is_action_just_pressed("space"):
				get_tree().quit()
				$MenuEnter.play(0)
		pass
