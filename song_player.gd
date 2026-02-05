extends AudioStreamPlayer

const START_AT_TICK:int = 0

func _on_game_clock_tick(current_tick:int) -> void:
	if !playing and current_tick == START_AT_TICK:
		play()
