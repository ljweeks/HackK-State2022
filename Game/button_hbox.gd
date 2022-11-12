extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum TYPES {BLOCK, MOVE_LEFT, MOVE_RIGHT, MOVE1, MOVE2, MOVE3, MOVE4}
export (TYPES) var type
export (Resource) var button_path
onready var current = get_node("current")
onready var complete = get_node("complete")
signal button_clicked
# Called when the node enters the scene tree for the first time.
func _ready():
	$button.set_normal_texture(button_path)
	$button.set_pressed_texture(button_path)
	
func _on_button_pressed():
	$current.modulate = Color.white
	emit_signal("button_clicked", type)
