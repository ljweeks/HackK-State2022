class_name character_selected_data
extends Node


var player1
var player2

signal character_selected

func _ready():
	player1 = Characters.CHARACTER_NAMES[0]
	player2 = Characters.CHARACTER_NAMES[0]

func _input(event):
	if event.is_action_pressed("dev_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
