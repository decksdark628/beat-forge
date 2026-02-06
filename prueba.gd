extends Node2D

@export var et:PackedScene
@onready var r: RhythmNotifier = $RhythmNotifier 
@onready var empty_target: Node2D = $EmptyTarget
var beat_length:float

func _ready() -> void:
	beat_length = r.beat_length
	_play_some_music()

#func _spawn_target() -> void:
	#empty_target.visible = true
	#var t = create_tween()
	#t.tween_property(empty_target, "position:x", 600, beat_length * 2)
	#t.tween_callback(func(): 
		#empty_target.visible = true
		#empty_target.position.x = -600
	#)

func _spawn_target() -> void:
	var n:Node2D = et.instantiate()
	n.position.x = -600
	get_tree().root.add_child(n)
	var t = create_tween()
	t.tween_property(n, "position:x", 600, beat_length * 2)
	t.tween_callback(func(): 
		n.queue_free()
	)

func _play_some_music():
	# Print every 4 beats, starting on beat 0.
	r.beats(4).connect(func(count): print("Hello from beat %d!" % (count * 4)))
	r.beats(4, true, 4).connect(func(_i): _spawn_target())

	r.audio_stream_player.play()  # Start signaling

	# Stop playback on beat 20.
	r.beats(0, false, 40).connect(func(_i): r.audio_stream_player.stop())
