extends AudioStreamPlayer

func play_win_sound() -> void:
	stream = load("res://sfx/win.wav")
	play()

func play_lose_sound() -> void:
	stream = load("res://sfx/lose.mp3")
	play()
