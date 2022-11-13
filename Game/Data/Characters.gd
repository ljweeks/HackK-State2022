extends Node


const GEN_FAKE = true
var CHARACTER_NAMES = []


func _ready():
	var dir = Directory.new()
	if dir.open("user://") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print("File name: ", file_name)
			if file_name.ends_with("res"):
				CHARACTER_NAMES.push_back(file_name)
			file_name = dir.get_next()
	
	if GEN_FAKE and CHARACTER_NAMES.size() <= 0:
		for i in range(0, 1):
			var char_data = Character.new()
			char_data.name = "Empty " + str(i)
			add_character(char_data)
	

func add_character(character):
	var filename = character.name.json_escape().strip_escapes().replace(' ', '') + ".res"
	CHARACTER_NAMES.push_back(filename)
	ResourceSaver.save("user://" + filename, character, ResourceSaver.FLAG_BUNDLE_RESOURCES & ResourceSaver.FLAG_CHANGE_PATH)

func get_character(char_name):
	var character = load("user://" + char_name).duplicate()
	character.get_hurt_boxes()
	return character

