extends Area2D


const DAMAGE := 20

onready var player = get_parent().get_parent()

var blood_particle = preload("res://Effects/blood_particle.tscn")

func _ready() -> void:
	connect("area_entered", self, "_area_entered")

func _area_entered(area: Area2D) -> void:
	if area is DamageBox:
		if area.player.player != player.player:
			var damaged = area.damage(DAMAGE)
			if damaged:
				var particle = blood_particle.instance()
				player.get_parent().add_child(particle)
				particle.global_position = global_position
				CameraEffects.hitstop(0.12)
