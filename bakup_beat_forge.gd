#extends Node2D
#
#const BALL_ANIM_DUR:float = 1.0
#
#const EASY:float = 0.35
#const MEDIUM:float = 0.25
#const HARD:float = 0.15
#
#const HIT_KEY_1:int = 1
#const HIT_KEY_2:int = 2
#const HIT_KEY_3:int = 3
#
#@onready var hammer_animator: AnimationPlayer = $Hammer/AnimationPlayer
#@onready var game_music: AudioStreamPlayer = $GameMusic
#@onready var count_down: AudioStreamPlayer = $CountDown
#@onready var song_timer: Timer = $SongTimer
#@onready var lbl_time: Label = $lblTime
##@onready var lbl_bpm: Label = $lblBPM
##@onready var lbl_feedback: Label = $lblFeedback
##@onready var lbl_target: Label = $lblTarget
#
#var beat_length:float
#var bpm:int = 60
#var song_started:bool = false
#var current_beat:int = -1
##var time_elapsed:float = 0.0
#var player_hit:float = -1.0
#var difficulty:float = EASY
#var song_length:float = 60.0
#var song:Array
#var current_target:Target
#var next_target:int = 1
#
##func _ready() -> void:
	##setup_game(145, 20)
#
#func setup_game(new_bpm:int, length:float):
	#song_started = false
	#current_beat = 0
	#player_hit = 0.0
	#time_elapsed = 0.0
	#bpm = new_bpm
	#beat_length = float(60)/bpm
	#song_length = length
	##lbl_bpm.text = "BPM: " + str(bpm)
	##song_timer.wait_time = length
	#setup_song()
	#countdown_and_start()
#
#func setup_song():
	#song =  []
	#song.append(Target.new(1*beat_length, HIT_KEY_1, 0.0))
	#song.append(Target.new(3*beat_length, HIT_KEY_1, 0.0))
	#song.append(Target.new(5*beat_length, HIT_KEY_1, 0.0))
	#song.append(Target.new(7*beat_length, HIT_KEY_1, 0.0))
	#song.append(Target.new(7*beat_length + (0.5*beat_length), HIT_KEY_1, 0.0))
	#current_target = song[0]
#
#func countdown_and_start():
	#for i in range(4, 0, -1):
		#count_down.play()
		#lbl_time.text = str(i)
		#await get_tree().create_timer(beat_length).timeout
	#lbl_time.text = "STARTED"
	#song_started = true
	#game_music.play()
	#song_timer.start()
#
#func _set_next_target() -> void:
	#next_target += 1
	#current_target = song[next_target]

#func _process(delta: float) -> void:
#	if song_started:
#		time_elapsed = song_timer.wait_time - song_timer.time_left
		#if time_elapsed > (current_target.time + difficulty):
			#_set_next_target()
			#print(time_elapsed)
			#print("incremented target to: " + str(next_target))
#		lbl_time.text = "%.2f" %time_elapsed

#		current_beat = int(time_elapsed/beat_length)
#		var target:int = (beat_length * current_beat) +1
#		lbl_target.text = "Target: " + str(target)
#		var comparison = target - player_hit
#		if comparison <= difficulty && comparison >= (difficulty * -1):
#			lbl_feedback.text = "GOOD: %.2f" %player_hit
#		else:
#			lbl_feedback.text = "BAD: %.2f" %player_hit
#
#func _compare(hit_key:int, hit_time:float, t:Target):
	#if hit_key == t.expected_input:
		#var distance:float = abs(hit_time - t.time)
		#if(distance <= difficulty):
			#return true
	#return false
#
#func _on_hammer_key_pressed(key:int) -> void:
	#player_hit = time_elapsed
	#print("hit time = " + str(time_elapsed))
	#hammer_animator.play("hit")
	#if _compare(key, player_hit, current_target):
		#print("\tBien")
	#else:
		#print("\tBad")
	
	
