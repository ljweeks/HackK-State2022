extends Control

enum {BLOCK, MOVE_LEFT, MOVE_RIGHT, MOVE1, MOVE2, MOVE3, MOVE4, NO_MOVE}

onready var cur_selected = BLOCK

onready var slider = get_node("VBoxContainer/HBoxContainer2/frame_select")
onready var start_frame = get_node("VBoxContainer/HBoxContainer/start") 
onready var stop_frame = get_node("VBoxContainer/HBoxContainer/stop")

var moves_ranges = {}

var moves_frames = {}
var moves_images = {}
var frame_data = []
var image_data = []
var all_checked = {BLOCK : false, MOVE_LEFT : false, MOVE_RIGHT : false, MOVE1 : false, MOVE2 : false, MOVE3 : false, MOVE4 : false}
var can_save
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalCameraServer.connect("record_finished", self, "_on_record_finished")
	can_save = false
	start_frame.min_value = 0
	stop_frame.min_value = 1
	$VBoxContainer2/save.modulate = Color.transparent
#	all_checked.BLOCK = false
#	all_checked.MOVE_LEFT = false
#	all_checked.MOVE_RIGHT = false
#	all_checked.MOVE1 = false
#	all_checked.MOVE2 = false
#	all_checked.MOVE3 = false
#	all_checked.MOVE4 = false
	$VBoxContainer2/block.connect("button_clicked", self, "_on_move_select")
	$VBoxContainer2/left.connect("button_clicked", self, "_on_move_select")
	$VBoxContainer2/right.connect("button_clicked", self, "_on_move_select")
	$VBoxContainer2/move1.connect("button_clicked", self, "_on_move_select")
	$VBoxContainer2/move2.connect("button_clicked", self, "_on_move_select")
	$VBoxContainer2/move3.connect("button_clicked", self, "_on_move_select")
	$VBoxContainer2/move4.connect("button_clicked", self, "_on_move_select")
	var nodes = get_tree().get_nodes_in_group("select_button")
	for node in nodes:
		node.current.modulate = Color.transparent
		if(node.type == BLOCK):
			node.current.modulate = Color.white

func _on_record_finished(images, frames):
	moves_images[cur_selected] = images
	moves_frames[cur_selected] = frames
	if(cur_selected == BLOCK):
		print("recorded block")
		$VBoxContainer2/block.complete.set_texture(load("res://Icons/checkmark.png"))
		all_checked[BLOCK] = true
	elif(cur_selected == MOVE_LEFT):
		print("recorded move left")
		$VBoxContainer2/left.complete.set_texture(load("res://Icons/checkmark.png"))
		all_checked[MOVE_LEFT] = true
	elif(cur_selected == MOVE_RIGHT):
		print("recorded move right")
		$VBoxContainer2/right.complete.set_texture(load("res://Icons/checkmark.png"))
		all_checked[MOVE_RIGHT] = true
	elif(cur_selected == MOVE1):
		print("recorder move 1")
		$VBoxContainer2/move1.complete.set_texture(load("res://Icons/checkmark.png"))
		all_checked[MOVE1] = true
		can_save = true
	elif(cur_selected == MOVE2):
		print("recorded move 2")
		$VBoxContainer2/move2.complete.set_texture(load("res://Icons/checkmark.png"))
		all_checked[MOVE2] = true
	elif(cur_selected == MOVE3):
		print("recorded move 3")
		$VBoxContainer2/move3.complete.set_texture(load("res://Icons/checkmark.png"))
		all_checked[MOVE3] = true
	elif(cur_selected == MOVE4):
		print("recorded move 4")
		$VBoxContainer2/move4.complete.set_texture(load("res://Icons/checkmark.png"))
		all_checked[MOVE4] = true
	var val = all_checked.values()
	#for item in val:
	#	if(not item):
	#		return
	if(can_save):
		$VBoxContainer2/save.modulate = Color.white

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_move_select(type):
	print("selecting")
	cur_selected = type
	var nodes = get_tree().get_nodes_in_group("select_button")
	for node in nodes:
		node.current.modulate = Color.transparent
		if(node.type == type):
			node.current.modulate = Color.white

func _on_record_toggled(button_pressed):
	if(button_pressed): #if the button is down we want to start recording
		print("Start recording")
		all_checked[cur_selected] = false
		if(not GlobalCameraServer.server_recording):
			GlobalCameraServer.start_record()
	else:
		print("Stop recording")
		GlobalCameraServer.end_record()


func _process(delta):
	if(cur_selected == BLOCK and all_checked[BLOCK] == true):
		display_preview(BLOCK)
	elif(cur_selected == MOVE_LEFT and all_checked[MOVE_LEFT] == true):
		display_preview(MOVE_LEFT)
	elif(cur_selected == MOVE_RIGHT and all_checked[MOVE_RIGHT] == true):
		display_preview(MOVE_RIGHT)
	elif(cur_selected == MOVE1 and all_checked[MOVE1] == true):
		display_preview(MOVE1)
	elif(cur_selected == MOVE2 and all_checked[MOVE2] == true):
		display_preview(MOVE2)
	elif(cur_selected == MOVE3 and all_checked[MOVE3] == true):
		display_preview(MOVE3)
	elif(cur_selected == MOVE4 and all_checked[MOVE4] == true):
		display_preview(MOVE4)
	else:
		display_preview(NO_MOVE)


func display_preview(move):
	#print("displaying preview for" + str(move))
	if(move == NO_MOVE):
		$VBoxContainer/frames.set_texture(GlobalCameraServer.get_preview_image())
		var bones = GlobalCameraServer.get_preview_frame()
		if(bones.size() > 0):
			for name in bones["character_colliders"].keys():
				var bone = bones["character_colliders"][name]
				var line = get_node("VBoxContainer/frames/" + name)
				line.set_point_position(0, Vector2(bone["x1"], bone["y1"]))
				line.set_point_position(1, Vector2(bone["x2"], bone["y2"]))
	else:
		slider.max_value = moves_frames[cur_selected].size()-1
		start_frame.max_value = moves_frames[cur_selected].size()-1
		stop_frame.max_value = moves_frames[cur_selected].size()-1
		$VBoxContainer/frames.set_texture(moves_images[cur_selected][slider.value])
		$VBoxContainer/HBoxContainer2/frame_number.text = str(slider.value)
		moves_ranges[cur_selected] = {'start': start_frame.value, 'stop' : stop_frame.value}
		var bones = moves_frames[cur_selected][slider.value]
		if(bones.size() > 0):
			for name in bones["character_colliders"].keys():
				var bone = bones["character_colliders"][name]
				var line = get_node("VBoxContainer/frames/" + name)
				line.set_point_position(0, Vector2(bone["x1"], bone["y1"]))
				line.set_point_position(1, Vector2(bone["x2"], bone["y2"]))





func _on_TextureButton_pressed():
	print("SAVE")
	if start_frame.value < stop_frame.value and can_save:
		if(not all_checked[MOVE2]):
			moves_frames[MOVE2] = moves_frames[MOVE1]
			moves_ranges[MOVE2] = moves_ranges[MOVE1]
			moves_images[MOVE2] = moves_images[MOVE1]
		if(not all_checked[MOVE3]):
			moves_frames[MOVE3] = moves_frames[MOVE1]
			moves_ranges[MOVE3] = moves_ranges[MOVE1]
			moves_images[MOVE3] = moves_images[MOVE1]
		if(not all_checked[MOVE4]):
			moves_frames[MOVE4] = moves_frames[MOVE1]
			moves_ranges[MOVE4] = moves_ranges[MOVE1]
			moves_images[MOVE4] = moves_images[MOVE1]
		var char_data = Character.new()
		char_data.name = $VBoxContainer/HBoxContainer/name.text
		char_data.move_frames = moves_frames
		char_data.move_ranges = moves_ranges
		char_data.move_images = moves_images
		char_data.get_hurt_boxes()
		Characters.add_character(char_data)
		get_tree().change_scene("res://Menus/character_select.tscn")


func _on_back_pressed():
	get_tree().change_scene("res://Menus/character_select.tscn")
