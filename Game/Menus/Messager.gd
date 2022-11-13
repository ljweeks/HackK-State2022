extends Label


const COUNTDOWN_TIME = 1.0
const COUNTDOWN_STEPS = 3

const VICTORY_TIME = 5.0

var countdown_step = 0
var time = 1

var finished = false

onready var three = $three
onready var two = $two
onready var one = $one
onready var begin = $begin

func _ready():
	get_tree().paused = true
	visible = true
	text = "1"

func _process(delta):
	time += delta
	if time > COUNTDOWN_TIME and countdown_step <= COUNTDOWN_STEPS:
		time = 0
		countdown_step += 1
		print(countdown_step)
		text = str(COUNTDOWN_STEPS - countdown_step + 1)
		if(text == '3'):
			three.play()
		if(text == '2'):
			two.play()
		if(text == '1'):
			one.play()
		if countdown_step == COUNTDOWN_STEPS + 1:
			begin.play()
			get_tree().paused = false
			visible = false
	
	if time >= VICTORY_TIME and finished:
		get_tree().change_scene("res://Menus/character_select.tscn")
	
	for obj in get_tree().get_nodes_in_group("player"):
		if obj.get_node("Sprite/damage_box").health == 0 and not finished:
			time = 0
			finished = true
			text = "Victory"
			visible = true

