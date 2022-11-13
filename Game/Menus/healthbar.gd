extends TextureProgress


export var player: int = 1

func _process(delta):
	for obj in get_tree().get_nodes_in_group("player"):
		if obj.player == player:
			value = obj.get_node("Sprite/damage_box").health
