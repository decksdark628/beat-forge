extends Node

const SUBDIVISIONS:int = 4

@onready var timer: Timer = $Timer
#var beat_count:int = 0
var tick_count:int = 0
var beat_length:float

signal tick
#signal beat

func _ready():
	timer.one_shot = false
	timer.timeout.connect(_on_tick)
	
func init_timer(bpm:int) -> void:
	beat_length = (60.0 / bpm) / SUBDIVISIONS
	timer.wait_time = beat_length
	#add_child(timer)
	timer.start()

func _on_tick():
	tick_count += 1
	tick.emit(tick_count)
	#print(str(tick_count))
	#if tick_count % SUBDIVISIONS == 0:
		#beat_count += 1
		#beat.emit(beat_count)

func get_tick_count_in_ms() -> float:
	return tick_count * beat_length

func get_time_since_last_tick() -> float:
	return beat_length - timer.time_left
