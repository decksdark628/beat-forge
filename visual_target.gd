extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
static var last_miss_up:bool = false

func appear_and_move() -> void:
	animation_player.play("go")

func reset() -> void:
	animation_player.play("RESET")

func _miss_anim() -> void:
	if last_miss_up:
		animation_player.play("miss_down")
		last_miss_up = false
	else:
		animation_player.play("miss_up")
		last_miss_up = true
