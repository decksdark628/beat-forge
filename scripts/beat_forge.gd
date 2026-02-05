extends Node2D

const FIRST_SONG_PATH:String = "res://song_data/song_00-120bpm.csv"

const BEAT_THRESHOLD:float = 0.15
const V_TARGET_ANIM_LATENCY_TICKS:int = 8
const V_TARGET_ANIM_LATENCY_SECONDS:float = 1.0
const V_TARGET_START_POS:Vector2 = Vector2(-1100, -13) 
const V_TARGET_END_POS:Vector2 = Vector2(379, -13)

@onready var song_importer: Node = $Jukebox/SongImporter
@onready var song_player: AudioStreamPlayer = $Jukebox/SongPlayer
@onready var clock: Node = $GameClock
@onready var hammer_anim_player: AnimationPlayer = $Hammer/AnimationPlayer
@onready var count_down_beep: AudioStreamPlayer = $GameClock/CountDownBeep
@onready var background: Node2D = $Background

var song:Song
var bpm:int
var beat_length:float
var song_length:float # TODO: que se determine en base al audio source cargado

var input_locked:bool = true # TODO: regresar al player

@export var v_target:PackedScene
var v_target_spawn_tracker:Array = [] # TODO: consider if its worth using a PackedByteArray for 8 booleans per entry
var current_target:Target
var n:int = 0
var max_n:int

func _ready() -> void:
	# IMPORT SONG
	song_importer.import_song(FIRST_SONG_PATH)
	song = song_importer.song
	bpm = song.bpm

	# FOR SHOWCASE OF THE EXPORT FUNCTIONALITY ONLY, DONT UNCOMMENT
	#song_importer.export_song(song)

	max_n = song.targets.size() - 1
	current_target = song.targets[n]
	
	# START
func start_game() -> void:
	clock.init_timer(bpm)
	count_down_beep.play()
	input_locked = false

func _next_target() -> void:
	if n < max_n:
		n += 1
		current_target = song.targets[n]

func _spawn_visual_target() -> void:
	var vt:Node2D = v_target.instantiate()
	vt.position = V_TARGET_START_POS
	background.add_child(vt)
	var move_to_target = create_tween()
	move_to_target.tween_property(
			vt,
			"position",
			V_TARGET_END_POS,
			V_TARGET_ANIM_LATENCY_SECONDS
		)

func _compare(hit:int, target:Target, time:float) -> bool:
	if (
		  ( hit == target.tick and time <= BEAT_THRESHOLD )
		  or
		  ( hit == target.tick - 1 and time >= (clock.beat_length - BEAT_THRESHOLD) )
		):
		return true
	return false

func _on_hammer_key_pressed(key:int) -> void:
	if key != current_target.expected_input:
		return
	var player_hit:int = clock.tick_count
	var time_since_prev:float = clock.get_time_since_last_tick()
	
	if _compare(player_hit, current_target, time_since_prev):
		hammer_anim_player.play("hit")
		_next_target()
	else:
		print("swing and miss")

func _on_game_clock_tick(current_tick:int) -> void:
	if current_tick + V_TARGET_ANIM_LATENCY_TICKS == current_target.tick:
		_spawn_visual_target()
	elif current_tick == current_target.tick:
		await get_tree().create_timer(BEAT_THRESHOLD).timeout
		_next_target()
