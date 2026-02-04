extends Node2D

const FIRST_SONG_PATH:String = "res://song_data/song_00-120bpm.csv"
const V_TARGET_ANIM_LATENCY:float = 1.0
const BEAT_THRESHOLD:float = 0.3

@onready var song_importer: Node = $Jukebox/SongImporter
@onready var song_player: AudioStreamPlayer = $Jukebox/SongPlayer
@onready var clock: Node = $GameClock
@onready var hammer_anim_player: AnimationPlayer = $Hammer/AnimationPlayer
#const SONG_LENGTH:float = 26.48

#@onready var hammer_animation_player: AnimationPlayer = $Hammer/AnimationPlayer
#@onready var song_player: AudioStreamPlayer = $SongPlayer

var song:Song
var bpm:int
var beat_length:float

@export var v_target:PackedScene
var input_locked:bool = true
var player_hit:float = 0.0
var last_tick:int = 0

var target_times:PackedFloat32Array = []
var v_target_spawn_times:PackedFloat32Array = []
var v_target_spawn_tracker:Array = [] # TODO: consider if its worth using a PackedByteArray for 8 booleans per entry
var current_target:float
var next_target:Target
var n:int = 0


func _ready() -> void:
	# IMPORT SONG
	song_importer.import_song(FIRST_SONG_PATH)
	song = song_importer.song
	bpm = song.bpm
	
	# FOR SHOWCASE OF EXPORT FUNCTIONALITY ONLY, DONT UNCOMMENT
	#song_importer.export_song(song)
	
	# GENERATE GAME DATA
	target_times.resize(song.targets.size())
	for i in range(0, song.targets.size()):
		target_times[i] = song.targets[i].tick * bpm

	v_target_spawn_times.resize(target_times.size())
	for i in range(0, v_target_spawn_times.size()):
		v_target_spawn_times[i] = target_times[i] - V_TARGET_ANIM_LATENCY

	v_target_spawn_tracker.resize(target_times.size())
	v_target_spawn_tracker.fill(false)
	current_target = target_times[n]

	# START
	clock.init_timer(bpm)
	song_player.play()
	input_locked = false

#func _process(delta: float) -> void:
	#time_elapsed = timer.wait_time - timer.time_left
	#while !target_spawn_tracker[n] and time_elapsed >= target_spawn_time[n]:
		#_spawn_target()
	#while time_elapsed >= current_target:
		#print("elapsed: " + str(time_elapsed) + " | target: " + str(current_target))
		#_next_target()

#func _next_target():
	#n += 1
	#current_target = targets[n]
#
#func _spawn_target():
	#target_spawn_tracker[n] = true
	#var target_node:Node2D = target_visual.instantiate()
	#target_node.game = self
	#target_node.position = Vector2(379, -13)
	#add_child(target_node)
	#print("spawn: " + str(time_elapsed))

func _compare(hit:float, target:float) -> bool:
	var difference:float = absf(hit - target)
	if difference > BEAT_THRESHOLD:
		return false
	return true

func _on_hammer_key_pressed(key:int):
	player_hit = clock.get_tick_count_in_ms() + clock.get_time_since_last_tick()
	#if key != song.targets[n].key:
		# print("miss")
	if _compare(player_hit, target_times[n]):
		hammer_anim_player.play("hit")
	else:
		print("miss")

func _on_game_clock_tick(current_tick:int) -> void:
	if current_target.tick == current_tick + 1:
		pass
