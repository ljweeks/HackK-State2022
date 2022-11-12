extends Node


var CHARACTERS = []


func _ready():
	for i in range(0, 3):
		var char_data = Character.new()
		char_data.name = "Empty " + str(i)
		add_character(char_data)

func add_character(character):
	CHARACTERS.append(character)

func get_character(char_name):
	for item in CHARACTERS:
		if item.name == char_name:
			return item

