extends Resource


var CHARACTERS = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_character(char_data):
	print("character added")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func get_character(char_name):
	for item in CHARACTERS:
		if(item.name == char_name):
			return item

