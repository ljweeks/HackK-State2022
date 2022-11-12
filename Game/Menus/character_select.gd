extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#create the item list for selectable characters
	for item in Characters.CHARACTERS:
		$player1/characterList1.add_item(item.name, null, true)
		$player2/characterList2.add_item(item.name, null, true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_create_pressed():
	get_tree().change_scene("res://Menus/create_character.tscn")


func _on_characterList2_item_selected(index):
	print("player 2 selected character " + str(Characters.CHARACTERS[index].name))
	CharactersSelectedData.player2 = Characters.CHARACTERS[index]


func _on_characterList1_item_selected(index):
	print("player 1 selected character " + str(Characters.CHARACTERS[index].name))
	CharactersSelectedData.player1 = Characters.CHARACTERS[index]

func _on_fight_pressed():
	
	get_tree().change_scene("res://test.tscn")
