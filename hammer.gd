extends Node2D

@onready var game: Node2D = $".."

signal key_pressed

#func _input(event: InputEvent):
	#if(!game.input_locked):
		#if(event.is_action_pressed("rhythm_game_key_1")):
			#key_pressed.emit(1)
		#if(event.is_action_pressed("rhythm_game_key_2")):
			#key_pressed.emit(2)
		#if(event.is_action_pressed("rhythm_game_key_3")):
			#key_pressed.emit(3)
