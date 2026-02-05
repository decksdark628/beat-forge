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
@onready var target_spawner: Node2D = $TargetSpawner
@onready var hammer: Node2D = $Hammer
@onready var hammer_anim_player: AnimationPlayer = $Hammer/AnimationPlayer
@onready var anvil: Node2D = $Anvil
@onready var count_down_beep: AudioStreamPlayer = $GameClock/CountDownBeep
@onready var background: Node2D = $Background

var song:Song
var bpm:int
var beat_length:float
var song_length:float # TODO: que se determine en base al audio source cargado

var input_locked:bool = true # TODO: regresar al player

@export var v_target:PackedScene
var v_target_spawn_tracker:Array = [] # TODO: consider if its worth using a PackedByteArray for 8 booleans per entry
var targets_tracker:Array = []
var current_target:Target
var n:int = 0
var vn:int = 0
var max_n:int

var current_tick:int = -100

func _ready() -> void:
	# IMPORT SONG
	song_importer.import_song(FIRST_SONG_PATH)
	song = song_importer.song
	bpm = song.bpm

	# FOR SHOWCASE OF THE EXPORT FUNCTIONALITY ONLY, DONT UNCOMMENT
	#song_importer.export_song(song)

	max_n = song.targets.size() - 1
	current_target = song.targets[n]
	targets_tracker.resize(song.targets.size())
	targets_tracker.fill(true)
	v_target_spawn_tracker.resize(song.targets.size())
	v_target_spawn_tracker.fill(true)
	
	# START
func start_game() -> void:
	clock.init_timer(bpm)
	count_down_beep.play()
	input_locked = false

func _next_target() -> void:
	targets_tracker[n] = false
	if n < max_n:
		n += 1
		current_target = song.targets[n]

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
	
	if targets_tracker[n] and _compare(player_hit, current_target, time_since_prev):
		anvil.throw_big_spark()
		targets_tracker[n] = false
		target_spawner.current.reset()
		target_spawner.next_v_target()
	else:
		anvil.throw_small_spark()

#func _on_game_clock_tick(current_tick:int) -> void:
func _on_game_clock_tick(t:int) -> void:
	current_tick = t

func _process(delta: float) -> void:
	if current_tick >= -4:
		if current_tick + V_TARGET_ANIM_LATENCY_TICKS >= current_target.tick and v_target_spawn_tracker[n]:
			prints(current_tick, current_target.tick)
			v_target_spawn_tracker[n] = false
			target_spawner.current.appear_and_move()
		elif current_tick >= current_target.tick:
			#prints(current_tick, current_target.tick)
			_next_target()
			#_wait_grace_period()

#func _wait_grace_period() -> void:
	#await get_tree().create_timer(BEAT_THRESHOLD).timeout
	#_next_target()
