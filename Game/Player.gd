extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2()

var jump_force = 500
var can_jump = false
var gravity = 0
export (int) var player = 1
export (int) var speed = 2000
var mirror = false
onready var animator = $Animator

enum {BLOCK, MOVE_LEFT, MOVE_RIGHT, MOVE1, MOVE2, MOVE3, MOVE4, NO_MOVE}

# Called when the node enters the scene tree for the first time.
func _ready():
	CharactersSelectedData.connect("character_selected", self, "change_character")
	check_mirror()
	change_character()
	

func change_character():
	if player == 1:
		animator.character = Characters.get_character(CharactersSelectedData.player1)
		animator.play(MOVE1)
		animator.stop()
	elif player == 2:
		animator.character = Characters.get_character(CharactersSelectedData.player2)
		animator.play(MOVE1)
		animator.stop()
	
func get_input(delta):
	var left_str = Input.get_action_strength("left" + str(player))
	var right_str = Input.get_action_strength("right" + str(player))
	
	if right_str > left_str:
		if not animator.playing:
			if(mirror):
				animator.play(MOVE_RIGHT)
			else:
				animator.play(MOVE_LEFT)
	if left_str > right_str:
		if not animator.playing:
			if(mirror):
				animator.play(MOVE_LEFT)
			else:
				animator.play(MOVE_RIGHT)
	
	vel.x -= left_str * speed * delta
	vel.x += right_str * speed * delta
	if(Input.is_action_just_pressed("block" + str(player))):
		attack(BLOCK)
	elif(Input.is_action_just_pressed("attack1-" + str(player))):
		attack(MOVE1)
	elif(Input.is_action_just_pressed("attack2-" + str(player))):
		attack(MOVE2)
	elif(Input.is_action_just_pressed("attack3-" +str(player))):
		attack(MOVE3)
	elif(Input.is_action_just_pressed("attack4-" + str(player))):
		attack(MOVE4)

func attack(move):
	print("did move " + str(move))
	animator.play(move)
	$MoveDust.restart()
	$MoveDust.emitting = true

func _process(delta):
	pass

func check_mirror():
	var groups = get_tree().get_nodes_in_group("player")
	var x = 0
	for item in groups:
		x += item.global_position.x
	if(global_position.x < (x / groups.size())):
		$Sprite.flip_h = false
		mirror = true
	else:
		$Sprite.flip_h = true
		mirror = false

func _physics_process(delta):
	check_mirror()
	
	if(is_on_floor()):
		can_jump = true
	
	vel.y += gravity * delta
	get_input(delta)
	vel = move_and_slide(vel, Vector2(0,-1))
	vel.x = vel.x*(0.85)

