extends Node2D

const FIRST_SONG_PATH:String = "res://song_data/song_00-120bpm.csv"
const V_TARGET_ANIM_LATENCY:float = 1.0

@onready var jukebox: Node = $Jukebox
@onready var clock: Node = $GameClock
#const SONG_LENGTH:float = 26.48

#@onready var hammer_animation_player: AnimationPlayer = $Hammer/AnimationPlayer
#@onready var song_player: AudioStreamPlayer = $SongPlayer

var song:Song
var bpm:int
var beat_length:float

@export var v_target:PackedScene
var input_locked:bool = true
var player_hit:float = 0.0

var target_times:PackedFloat32Array = []
var v_target_spawn_times:PackedFloat32Array = []
var v_target_spawn_tracker:Array = [] # TODO: consider if its worth using a PackedByteArray for 8 booleans per entry
var current_target:float
var n:int = 0


func _ready() -> void:
	# IMPORT SONG
	jukebox.import_song(FIRST_SONG_PATH)
	song = jukebox.song
	bpm = song.bpm
	
	# GENERATE GAME DATA
	current_target = target_times[n]
	target_times.resize(song.targets.size())
	for i in range(0, song.targets.size()):
		target_times[i] = song.targets[i].tick * bpm

	v_target_spawn_times.resize(target_times.size())
	for i in range(0, v_target_spawn_times.size()):
		v_target_spawn_times[i] = target_times[i] - V_TARGET_ANIM_LATENCY

	v_target_spawn_tracker.resize(target_times.size())
	v_target_spawn_tracker.fill(false)

	# START
	#song_player.play()
	#input_locked = false


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
	#
#func _on_hammer_key_pressed(key:int) -> void:
	#player_hit = time_elapsed
	#hammer_animation_player.play("hit")
#
#
#func _on_timer_timeout() -> void:
	#current_beat += 1
