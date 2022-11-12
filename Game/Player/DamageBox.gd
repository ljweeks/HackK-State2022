class_name DamageBox
extends Area2D


const INVULN_TIME := 0.2

onready var player = get_parent().get_parent()

var health := 100

var last_hit := INF


func damage(amount: int) -> void:
	if last_hit > INVULN_TIME:
		health = max(health - amount, 0)
		player.get_node("WhiteFlash").play("flash")
		print("Player " + str(player.player) + " hit")

func _physics_process(delta):
	last_hit += delta
