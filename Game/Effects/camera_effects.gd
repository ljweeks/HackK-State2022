extends Node

var screenshakeOffset := Vector2.ZERO
var trauma := 0.0

var time := 0.0

var noise: OpenSimplexNoise

var hitstopEndTime: float

func _ready():
	noise = OpenSimplexNoise.new()
	noise.octaves = 4
	noise.period = 0.3
	noise.persistence = 0.8

func _process(delta):
	time += delta
	trauma = clamp(trauma - delta, 0, 1)
	screenshakeOffset.x = 128.0 * trauma * trauma * noise.get_noise_1d(time)
	screenshakeOffset.y = 128.0 * trauma * trauma * noise.get_noise_1d(time + 100.0)
	if OS.get_ticks_msec() > hitstopEndTime:
		Engine.time_scale = 1.0

func hitstop(duration):
	Engine.time_scale = 0.0
	hitstopEndTime = OS.get_ticks_msec() + duration * 1000
