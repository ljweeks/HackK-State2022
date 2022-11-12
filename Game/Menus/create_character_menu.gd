extends Control

enum {BLOCK, MOVE_LEFT, MOVE_RIGHT, MOVE1, MOVE2, MOVE3, MOVE4}

onready var cur_selected = BLOCK
var all_checked = {}
onready var slider = get_node("VBoxContainer/HBoxContainer2/frame_select")
onready var start_frame = get_node("VBoxContainer/HBoxContainer/start") 
onready var stop_frame = get_node("VBoxContainer/HBoxContainer/stop")
var can_save
# Called when the node enters the scene tree for the first time.
func _ready():
	can_save = false
	start_frame.min_value = 0
	stop_frame.min_value = 1
	$VBoxContainer2/save.modulate = Color.transparent
	all_checked.BLOCK = false
	all_checked.MOVE_LEFT = false
	all_checked.MOVE_RIGHT = false
	all_checked.MOVE1 = false
	all_checked.MOVE2 = false
	all_checked.MOVE3 = false
	all_checked.MOVE4 = false
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
	else:
		print("Stop recording")
		if(cur_selected == BLOCK):
			print("recorded block")
			$VBoxContainer2/block.complete.set_texture(load("res://Icons/checkmark.png"))
			all_checked.BLOCK = true
		elif(cur_selected == MOVE_LEFT):
			print("recorded move left")
			$VBoxContainer2/left.complete.set_texture(load("res://Icons/checkmark.png"))
			all_checked.MOVE_LEFT = true
		elif(cur_selected == MOVE_RIGHT):
			print("recorded move right")
			$VBoxContainer2/right.complete.set_texture(load("res://Icons/checkmark.png"))
			all_checked.MOVE_RIGHT = true
		elif(cur_selected == MOVE1):
			print("recorder move 1")
			$VBoxContainer2/move1.complete.set_texture(load("res://Icons/checkmark.png"))
			all_checked.MOVE1 = true
		elif(cur_selected == MOVE2):
			print("recorded move 2")
			$VBoxContainer2/move2.complete.set_texture(load("res://Icons/checkmark.png"))
			all_checked.MOVE2 = true
		elif(cur_selected == MOVE3):
			print("recorded move 3")
			$VBoxContainer2/move3.complete.set_texture(load("res://Icons/checkmark.png"))
			all_checked.MOVE3 = true
		elif(cur_selected == MOVE4):
			print("recorded move 4")
			$VBoxContainer2/move4.complete.set_texture(load("res://Icons/checkmark.png"))
			all_checked.MOVE4 = true
	var val = all_checked.values()
	for item in val:
		if(not item):
			return
	$VBoxContainer2/save.modulate = Color.white
	can_save = true


func _on_TextureButton_pressed():
	if(start_frame.value < stop_frame.value and can_save):
		print("save character")
