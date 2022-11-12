class_name Character
extends Resource

enum {BLOCK, MOVE_LEFT, MOVE_RIGHT, MOVE1, MOVE2, MOVE3, MOVE4, NO_MOVE}

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
func get_hurt_boxes():
	hurt_box_for_move(MOVE1)
	hurt_box_for_move(MOVE2)
	hurt_box_for_move(MOVE3)
	hurt_box_for_move(MOVE4)	
	
func hurt_box_for_move(move):
	var largest = 0
	var largest_box
	var frame_number
	var index = 0
	for frame in move_frames[move]:
		if(abs(frame["hurtboxes"]["left_hand"]["x"])-320 > largest):
			largest = abs(frame["hurtboxes"]["left_hand"]["x"])-320
			largest_box = "left_hand"
			frame_number = index
		if(abs(frame["hurtboxes"]["right_hand"]["x"])- 320 > largest):
			largest = abs(frame["hurtboxes"]["right_hand"]["x"])- 320
			largest_box = "right_hand"
			frame_number = index
		if(abs(frame["hurtboxes"]["left_foot"]["x"])- 320 > largest):
			largest = abs(frame["hurtboxes"]["left_foot"]["x"]) -320
			largest_box = "left_foot"
			frame_number = index
		if(abs(frame["hurtboxes"]["right_foot"]["x"]) - 320 > largest):
			largest = abs(frame["hurtboxes"]["right_foot"]["x"]) -320
			largest_box = "right_foot"
			frame_number = index
		index += 1
		if(index > move_ranges[move]["stop"]):
			break
	move_frames[move][frame_number-1]["hurtboxes"][largest_box]["active"] = true
	print("move-" + str(move) + " frame-" + str(frame_number-1) + " for-" + largest_box)
	
