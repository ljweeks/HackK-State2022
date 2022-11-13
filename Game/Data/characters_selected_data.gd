class_name character_selected_data
extends Node


var player1
var player2

signal character_selected

func _ready():
	player1 = Characters.CHARACTERS[0]
	player2 = Characters.CHARACTERS[0]
