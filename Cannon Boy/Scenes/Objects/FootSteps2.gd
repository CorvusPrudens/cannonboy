extends Node2D

export(Array, AudioStream) var streams
var play:bool = false

var fpath = ["res://Assets/Audio/SFX/Player/footstep/footstep1.wav", 
			"res://Assets/Audio/SFX/Player/footstep/footstep2.wav",
			"res://Assets/Audio/SFX/Player/footstep/footstep3.wav"]

var cpath = ["res://Assets/Audio/SFX/Player/chain/chain1.wav",
			"res://Assets/Audio/SFX/Player/chain/chain2.wav",
			"res://Assets/Audio/SFX/Player/chain/chain3.wav",
			"res://Assets/Audio/SFX/Player/chain/chain4.wav",
			"res://Assets/Audio/SFX/Player/chain/chain5.wav"]

var sdamage
var sshoot
var sitemget
var skill


var footsteps = []
var chains = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(fpath.size()):
		var temp = AudioStreamPlayer.new()
		var tempFile = load(fpath[i])
		temp.stream = tempFile
		temp.bus = "SFX"
		footsteps.append(temp)
		add_child(temp)
	for i in range(cpath.size()):
		var temp = AudioStreamPlayer.new()
		var tempFile = load(cpath[i])
		temp.stream = tempFile
		temp.bus = "QSFX"
		chains.append(temp)
		add_child(temp)
	
	sdamage = AudioStreamPlayer.new()
	var tempFile = load("res://Assets/Audio/SFX/Player/playerDamage.wav")
	sdamage.stream = tempFile
	sdamage.bus = "SFX"
	add_child(sdamage)
	
	sitemget = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Player/itemGet.wav")
	sitemget.stream = tempFile
	sitemget.bus = "SFX"
	add_child(sitemget)
	
	sshoot = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Player/shootGrapple.wav")
	sshoot.stream = tempFile
	sshoot.bus = "SFX"
	add_child(sshoot)
	
	skill = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Player/EnemyKill.wav")
	skill.stream = tempFile
	skill.bus = "SFX"
	add_child(skill)

func footstep():
	var index = rand_range(0, footsteps.size())
	footsteps[index].pitch_scale = rand_range(0.9, 1.1)
	footsteps[index].play()

func chain():
	if randf() > 0.5:
		var index = rand_range(0, chains.size())
		chains[index].pitch_scale = rand_range(0.9, 1.1)
		chains[index].play()

func damage():
	sdamage.pitch_scale = rand_range(0.9, 1.1)
	sdamage.play()

func itemGet():
	sitemget.pitch_scale = rand_range(0.9, 1.1)
	sitemget.play()
	
func shoot():
	sshoot.pitch_scale = rand_range(0.9, 1.1)
	sshoot.play()

func shootStop():
	if sshoot.playing:
		sshoot.stop()

func kill():
	skill.pitch_scale = rand_range(0.9, 1.1)
	skill.play()