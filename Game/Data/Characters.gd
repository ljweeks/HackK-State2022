extends Node


var CHARACTERS = []


func add_character(character):
	CHARACTERS.append(character)

func get_character(char_name):
	for item in CHARACTERS:
		if item.name == char_name:
			return item

