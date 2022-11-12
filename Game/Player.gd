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
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func get_input(delta):

	vel.x -= Input.get_action_strength("left" + str(player)) * speed * delta
	vel.x += Input.get_action_strength("right" + str(player)) * speed * delta
	
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

