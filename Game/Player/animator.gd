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

func _ready():
	var damage_box = sprite.get_node("damage_box")
	var owners = damage_box.get_shape_owners()
	for owner in owners:
		var shape_count = damage_box.shape_owner_get_shape_count(owner)
		var shape_owner_obj = damage_box.shape_owner_get_owner(owner)
		var shape_obj = null
		for shape in range(0, shape_count):
			shape_obj = damage_box.shape_owner_get_shape(owner, shape)
		damage_box.shape_owner_clear_shapes(owner)
		shape_obj = shape_obj.duplicate(true)
		damage_box.shape_owner_add_shape(owner, shape_obj)
		shape_owner_obj.set_shape(shape_obj)

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

func flip_x_coord(x: float) -> float:
	if not player.mirror:
		return 640 - x
	return x

func show_frame(image, frame):
	sprite.texture = image
	var bones = frame['character_colliders']
	
	var damage_box: Area2D = sprite.get_node('damage_box')
	var owners = damage_box.get_shape_owners()
	for owner in owners:
		var shape_count = damage_box.shape_owner_get_shape_count(owner)
		var shape_owner_name = damage_box.shape_owner_get_owner(owner).name
		if shape_owner_name in bones:
			var bone = bones[shape_owner_name]
			for shape in range(0, shape_count):
				var shape_obj = damage_box.shape_owner_get_shape(owner, shape)
				shape_obj.b = Vector2(flip_x_coord(bone["x1"]), bone["y1"])
				shape_obj.a = Vector2(flip_x_coord(bone["x2"]), bone["y2"])
	
	var hurtboxes = frame['hurtboxes']
	for key in hurtboxes.keys():
		var box = hurtboxes[key]
		var active = false
		if 'active' in box and box['active']:
			active = true
		var hurtbox = sprite.get_node(key)
		hurtbox.position = Vector2(flip_x_coord(box['x']), box['y'])
		hurtbox.monitoring = active
		hurtbox.monitorable = active

func _physics_process(delta: float) -> void:
	if playing:
		anim_time += delta
		if anim_time > anim_ranges['stop'] * FRAME_TIME:
			stop()
		else:
			var last_index = frame_index
			frame_index = int(floor(anim_time / FRAME_TIME)) + anim_ranges['start']
			frame_index = min(frame_index, anim_images.size() - 1)
			if frame_index != last_index:
				show_frame(anim_images[frame_index], anim_frames[frame_index])
