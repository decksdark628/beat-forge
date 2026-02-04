extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var game
func _ready() -> void:
	pass

func mid_point() -> void:
	print("MID: " + str(game.time_elapsed))

func _disappear() -> void:
	queue_free()

func _process(delta: float) -> void:
	pass
