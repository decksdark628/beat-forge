extends Node2D

const UP_POSITION = Vector2(-256,-192)
const DOWN_POSITION = Vector2(-256,-32)

func _ready() -> void:
	position = UP_POSITION

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent):
	if(event.is_action_pressed("ui_accept")):
		position = DOWN_POSITION
		await get_tree().create_timer(0.25).timeout
		position = UP_POSITION
