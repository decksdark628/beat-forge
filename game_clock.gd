extends Node

@onready var timer: Timer = $Timer

@export var subdivision:int = 4
var beat_count:int = 0
var tick_count:int = 0

signal tick
signal beat

func _ready():
	timer.one_shot = false
	timer.timeout.connect(_on_tick)
	
func init_beat_timer(bpm:int) -> void:
	timer.wait_time = (60.0 / bpm) / subdivision
	#add_child(timer)
	timer.start()

func _on_tick():
	tick_count += 1
	tick.emit(tick_count)
	#print(str(beat_count) + " - " + str(tick_count))
	if tick_count % subdivision == 0:
		beat_count += 1
		beat.emit(beat_count)
