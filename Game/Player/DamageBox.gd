class_name DamageBox
extends Area2D


const INVULN_TIME := 0.2

onready var player = get_parent().get_parent()

var health := 100

var last_hit := INF

enum {BLOCK, MOVE_LEFT, MOVE_RIGHT, MOVE1, MOVE2, MOVE3, MOVE4, NO_MOVE}

func damage(amount: int) -> bool:
	if last_hit > INVULN_TIME:
		if(player.animator.cur_move == BLOCK):
			health = max(health - (amount / 5), 0)
		else:
			health = max(health - amount, 0)
		player.get_node("WhiteFlash").play("flash")
		player.animator.stop()
		player.animator.play(MOVE_LEFT)
		if(player.mirror):
			player.vel.x -= 2000
		else:
			player.vel.x += 2000
		print("Player " + str(player.player) + " hit")
		if health <= 0:
			player.get_node("DeathAnim").play("death")
		return true
	return false

func _physics_process(delta):
	last_hit += delta
