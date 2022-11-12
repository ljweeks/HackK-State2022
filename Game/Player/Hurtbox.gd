extends Area2D


const DAMAGE := 20

onready var player = get_parent().get_parent()


func _ready() -> void:
	connect("area_entered", self, "_area_entered")

func _area_entered(area: Area2D) -> void:
	if area is DamageBox:
		if area.player.player != player.player:
			area.damage(DAMAGE)
