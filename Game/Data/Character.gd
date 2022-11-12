class_name Character
extends Resource

export var move_frames = {}

export var move_ranges = {}

export var move_images = {}

export var name = ""

func get_images(move):
	var images = []
	if move_images.has(move):
		images = move_images[move]
	if len(images) > 0:
		return images
	images = []
	images.append(null)
	return images

func get_frames(move):
	var frames = []
	if move_frames.has(move):
		frames = move_frames[move]
	if len(frames) > 0:
		return frames
	frames = []
	frames.append(_harmless_frame())
	return frames

func get_range(move):
	if move_ranges.has(move):
		var ranges = move_ranges[move]
		if len(ranges) > 0:
			return ranges
	return {'start': 0, 'stop': 0}

func _harmless_frame():
	return {
		'character_colliders': {},
		'hurtboxes': {}
	}
	
#HURT BOX GENERATION
