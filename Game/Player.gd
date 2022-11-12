extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2()
var speed = 2000
var jump_force = 500
var can_jump = false
var gravity = 1000
export (int) var player = 1

onready var animator = $Animator

enum {BLOCK, MOVE_LEFT, MOVE_RIGHT, MOVE1, MOVE2, MOVE3, MOVE4, NO_MOVE}

# Called when the node enters the scene tree for the first time.
func _ready():
	if player == 1:
		animator.character = CharactersSelectedData.player1
	elif player == 2:
		animator.character = CharactersSelectedData.player2


func get_input(delta):
	var left_str = Input.get_action_strength("left" + str(player))
	var right_str = Input.get_action_strength("right" + str(player))
	
	if right_str > left_str:
		if not animator.playing:
			animator.play(MOVE_RIGHT)
	
	vel.x -= left_str * speed * delta
	vel.x += right_str * speed * delta
	
	if(Input.get_action_strength("up" + str(player)) > 0.8 and can_jump):
		print("jump")
		can_jump = false
		vel.y -= jump_force
		



func _process(delta):
	pass

func _physics_process(delta):
	
	var groups = get_tree().get_nodes_in_group("player")
	var x = 0
	for item in groups:
		x += item.global_position.x
	if(global_position.x < (x / groups.size())):
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	if(is_on_floor()):
		can_jump = true
	
	vel.y += gravity * delta
	get_input(delta)
	vel = move_and_slide(vel, Vector2(0,-1))
	vel.x = vel.x*(0.85)

