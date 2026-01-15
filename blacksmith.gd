extends Node2D

@onready var song_timer: Timer = $SongTimer
@onready var lbl_time: Label = $lblTime
@onready var lbl_bpm: Label = $lblBPM
@onready var lbl_feedback: Label = $lblFeedback
@onready var lbl_target: Label = $lblTarget
var bpm:int
var beat_length
var song_started:bool
var current_beat:int
var time_elapsed:float
var player_hit:float
var difficulty:float

func _ready() -> void:
	bpm = 60
	beat_length = 60/bpm
	player_hit = 0.0
	difficulty = 0.15
	song_started = false
	setup_song(60, 60.0)

func setup_song(new_bpm:int, length:float):
	bpm = new_bpm
	beat_length = 60/bpm
	lbl_bpm.text = "BPM: " + str(bpm)
	song_timer.wait_time = length
	current_beat = 0
	player_hit = 0.0
	time_elapsed = 0.0
	countdown_and_start()

func countdown_and_start():
	for i in range(4, 1, -1):
		lbl_time.text = str(i)
		await get_tree().create_timer(beat_length).timeout
	song_started = true
	song_timer.start()

func _process(delta: float) -> void:
	if song_started:
		time_elapsed = song_timer.wait_time - song_timer.time_left
		lbl_time.text = "%.2f" %time_elapsed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		# TODO: REFACTOR to keep the judging of input separated from the song timer
		#       Try to encapsulate timer, judging and scheduler events. All 3 should be independent
		player_hit = time_elapsed
		current_beat = int(time_elapsed/beat_length)
		var target:int = (beat_length * current_beat) +1
		lbl_target.text = "Target: " + str(target)
		var comparison = target - player_hit
		if comparison <= difficulty && comparison >= (difficulty * -1):
			lbl_feedback.text = "GOOD: %.2f" %player_hit
		else:
			lbl_feedback.text = "BAD: %.2f" %player_hit
