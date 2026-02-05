extends Node2D

@onready var game: Node2D = $".."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal key_pressed

func _input(event: InputEvent):
	if !game.input_locked:
		if event.is_action_pressed("ui_accept"):
			key_pressed.emit(1)
			animation_player.play("hit")
		elif event.is_action_released("ui_accept"):
			animation_player.play("release")
		#if(event.is_action_pressed("rhythm_game_key_2")):
			#key_pressed.emit(2)
		#if(event.is_action_pressed("rhythm_game_key_3")):
			#key_pressed.emit(3)
