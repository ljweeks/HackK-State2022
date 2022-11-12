extends Node

const FPS := 10.0
const FRAME_TIME := 1.0 / FPS

var character: Character = Character.new()

var cur_move = -1

var frame_index := 0
var anim_time := 0.0

var anim_images := []
var anim_frames := []
var anim_ranges := {}

var playing := false

onready var player = get_parent()
onready var sprite = player.get_node("Sprite")

func play(move) -> void:
	anim_images = character.get_images(move)
	anim_ranges = character.get_range(move)
	anim_frames = character.get_frames(move)
	frame_index = anim_ranges['start']
	anim_time = 0
	playing = true
	cur_move = move
	show_frame(anim_images[frame_index], anim_frames[frame_index])

func stop() -> void:
	playing = false
	anim_time = 0
	cur_move = -1

func show_frame(image, frame):
	sprite.texture = image

func _physics_process(delta: float) -> void:
	if playing:
		anim_time += delta
		if anim_time > anim_ranges['stop'] * FRAME_TIME:
			stop()
		else:
			var last_index = frame_index
			frame_index = int(floor(anim_time / FRAME_TIME)) + anim_ranges['start']
			if frame_index != last_index:
				show_frame(anim_images[frame_index], anim_frames[frame_index])
