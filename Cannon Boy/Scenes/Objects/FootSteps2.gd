extends Node2D

export(Array, AudioStream) var streams
var play:bool = false

var fpath = ["res://Assets/Audio/SFX/Player/footstep/CrunchStep.wav"]

var cpath = ["res://Assets/Audio/SFX/Player/chain/chain1.wav",
			"res://Assets/Audio/SFX/Player/chain/chain2.wav",
			"res://Assets/Audio/SFX/Player/chain/chain3.wav",
			"res://Assets/Audio/SFX/Player/chain/chain4.wav",
			"res://Assets/Audio/SFX/Player/chain/chain5.wav"]

var sdamage
var sshoot
var sitemget
var skill
var sjump
var sland
var stinger2
var stinger3


var footsteps = []
var chains = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(fpath.size()):
		var temp = AudioStreamPlayer.new()
		var tempFile = load(fpath[i])
		temp.stream = tempFile
		temp.bus = "SFX"
		temp.set_volume_db(-6)
		footsteps.append(temp)
		add_child(temp)
	for i in range(cpath.size()):
		var temp = AudioStreamPlayer.new()
		var tempFile = load(cpath[i])
		temp.stream = tempFile
		temp.bus = "SFX"
		temp.set_volume_db(-12)
		chains.append(temp)
		add_child(temp)
	
	sdamage = AudioStreamPlayer.new()
	var tempFile = load("res://Assets/Audio/SFX/Player/playerHit.wav")
	sdamage.stream = tempFile
	sdamage.bus = "SFX"
	sdamage.set_volume_db(2)
	add_child(sdamage)
	
	sitemget = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Player/itemGet.wav")
	sitemget.stream = tempFile
	sitemget.bus = "SFX"
	sitemget.set_volume_db(0)
	add_child(sitemget)
	
	sshoot = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Player/shootGrapple.wav")
	sshoot.stream = tempFile
	sshoot.bus = "SFX"
	sshoot.set_volume_db(-2)
	add_child(sshoot)
	
	skill = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Player/EnemyKill.wav")
	skill.stream = tempFile
	skill.bus = "SFX"
	skill.set_volume_db(-2)
	add_child(skill)
	
	sjump = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Player/jump.wav")
	sjump.stream = tempFile
	sjump.bus = "SFX"
	sjump.set_volume_db(-4)
	add_child(sjump)
	
	sland = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Player/landing.wav")
	sland.stream = tempFile
	sland.bus = "SFX"
	sland.set_volume_db(-5)
	add_child(sland)
	
	stinger2 = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Stingers/Stinger2.wav")
	stinger2.stream = tempFile
	stinger2.bus = "SFX"
	stinger2.set_volume_db(0)
	add_child(stinger2)
	
	stinger3 = AudioStreamPlayer.new()
	tempFile = load("res://Assets/Audio/SFX/Stingers/Stinger3.wav")
	stinger3.stream = tempFile
	stinger3.bus = "SFX"
	stinger3.set_volume_db(6)
	add_child(stinger3)

func footstep():
	var go = true
	for i in range(footsteps.size()):
		if footsteps[i].playing:
			go = false
			break
	if go:
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

func jump():
	sjump.pitch_scale = rand_range(0.9, 1.1)
	sjump.play()

func land():
	sland.pitch_scale = rand_range(0.9, 1.1)
	sland.play()

func kill():
	skill.pitch_scale = rand_range(0.9, 1.1)
	skill.play()
	
func singer2():
	stinger2.play()
	
func stinger3():
	stinger3.play()