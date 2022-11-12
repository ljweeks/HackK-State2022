extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var data = get_node("res://Data/Characters.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	#create the item list for selectable characters
	for item in data.CHARACTERS:
		$player1/characterList1.add_item(item.name, null, true)
		$player2/characterList2.add_item(item.name, null, true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
