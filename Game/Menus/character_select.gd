extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var selectIndex1 = 0
	var selectIndex2 = 0
	var index = 0
	for item in Characters.CHARACTER_NAMES:
		$player1/characterList1.add_item(item, null, true)
		if item == CharactersSelectedData.player1.json_escape().strip_escapes().replace(' ', '') + ".res":
			selectIndex1 = index
		$player2/characterList2.add_item(item, null, true)
		if item == CharactersSelectedData.player2.json_escape().strip_escapes().replace(' ', '') + ".res":
			selectIndex2 = index
		index += 1
	$player1/characterList1.select(selectIndex1)
	$player2/characterList2.select(selectIndex2)
	GlobalCameraServer.disable_preview()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_create_pressed():
	get_tree().change_scene("res://Menus/create_character.tscn")


func _on_characterList2_item_selected(index):
	print("player 2 selected character " + str(Characters.CHARACTER_NAMES[index]))
	CharactersSelectedData.player2 = Characters.CHARACTER_NAMES[index]
	CharactersSelectedData.emit_signal("character_selected")


func _on_characterList1_item_selected(index):
	print("player 1 selected character " + str(Characters.CHARACTER_NAMES[index]))
	CharactersSelectedData.player1 = Characters.CHARACTER_NAMES[index]
	CharactersSelectedData.emit_signal("character_selected")

func _on_fight_pressed():
	
	get_tree().change_scene("res://test.tscn")
