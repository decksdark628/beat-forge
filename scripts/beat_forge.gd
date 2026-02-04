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
@onready var background: Node2D = $Background

var song:Song
var bpm:int
var beat_length:float
var song_length:float # por implementar

@export var v_target:PackedScene
var input_locked:bool = true
var last_tick:int = 0

#var target_times:PackedFloat32Array = []
#var v_target_spawn_times:PackedFloat32Array = []
var v_target_spawn_tracker:Array = [] # TODO: consider if its worth using a PackedByteArray for 8 booleans per entry
var current_target:Target
var n:int = 0


func _ready() -> void:
	# IMPORT SONG
	song_importer.import_song(FIRST_SONG_PATH)
	song = song_importer.song
	bpm = song.bpm
	
	# FOR SHOWCASE OF EXPORT FUNCTIONALITY ONLY, DONT UNCOMMENT
	#song_importer.export_song(song)
	
	# GENERATE GAME DATA
	#target_times.resize(song.targets.size())
	#for i in range(0, song.targets.size()):
		#target_times[i] = song.targets[i].tick * bpm
#
	#v_target_spawn_times.resize(target_times.size())
	#for i in range(0, v_target_spawn_times.size()):
		#v_target_spawn_times[i] = target_times[i] - V_TARGET_ANIM_LATENCY
#
	#v_target_spawn_tracker.resize(target_times.size())
	#v_target_spawn_tracker.fill(false)
	#current_target = target_times[n]

	# START
func start_game() -> void:
	clock.init_timer(bpm)
	song_player.play()
	input_locked = false

func _next_target():
	n += 1
	current_target = song.targets[n]

func _spawn_visual_target():
	var vt:Node2D = v_target.instantiate()
	vt.position = V_TARGET_START_POS
	background.add_child(vt)
	var move_to_target = create_tween()
	move_to_target.tween_property(vt, "position", V_TARGET_END_POS, V_TARGET_ANIM_LATENCY_SECONDS)

func _compare(hit:int, target:Target, time:float) -> bool:
	if ( hit == target.tick and time <= BEAT_THRESHOLD ) or ( hit == target.tick - 1 and time >= (clock.beat_length - BEAT_THRESHOLD) ):
		return true
	return false

func _on_hammer_key_pressed(key:int):
	if key != current_target.key:
		return
	var player_hit:int = clock.tick_count
	var time_since_prev:float = clock.get_time_last_tick()
	
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
