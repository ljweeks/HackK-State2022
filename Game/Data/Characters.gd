extends Node


const GEN_FAKE = true
var CHARACTERS = []


func _ready():
	var dir = Directory.new()
	if dir.open("user://") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print("File name: ", file_name)
			if file_name.ends_with("res"):
				CHARACTERS.push_back(load("user://" + file_name))
			file_name = dir.get_next()
	
	if GEN_FAKE and CHARACTERS.size() <= 0:
		for i in range(0, 3):
			var char_data = Character.new()
			char_data.name = "Empty " + str(i)
			add_character(char_data)
	

func add_character(character):
	CHARACTERS.append(character)
	var filename = character.name.json_escape().strip_escapes().replace(' ', '') + ".res"
	ResourceSaver.save("user://" + filename, character, ResourceSaver.FLAG_BUNDLE_RESOURCES & ResourceSaver.FLAG_CHANGE_PATH)

func get_character(char_name):
	for item in CHARACTERS:
		if item.name == char_name:
			return item

