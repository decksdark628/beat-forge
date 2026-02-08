extends Node2D

const TEST_SONG_PATH:String = "res://song_data/song_01-135bpm.csv"
const SPAWN_AHEAD_TIME:float = 1.0
const MISS_THRESHOLD:float = 0.1

@export var visual_target:PackedScene

@onready var rn: RhythmNotifier = $RhythmNotifier
@onready var importer: Node = $SongImporter
@onready var hammer: Node2D = $Hammer
@onready var player: AudioStreamPlayer = $SongPlayer
@onready var target_spawner: Node2D = $TargetSpawner
@onready var anvil: Node2D = $Anvil
@onready var score_tracker: PanelContainer = $ScoreTracker
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

var visual_targets:Array = []
var targets:PackedFloat32Array =  []
var current_target:float
var t_index:int = 0
var spawn_index:int = 0

func _ready() -> void:
	importer.import_song(TEST_SONG_PATH)
	rn.bpm = importer.song.bpm
	
	for t in importer.song.targets:
		targets.append(t.beat * rn.beat_length)
	current_target = targets[t_index]
	
	score_tracker.score = 0
	score_tracker.max_score = targets.size() * 10
	score_tracker.min_score = targets.size() * -5
	score_tracker.update_score_bar()
	
	rn.beats(0, false, 44).connect(func(_i): 
		rn.audio_stream_player.stop()
		score_tracker.game_over()
		hammer._lock_input()
	)

func start_game():
	rn.audio_stream_player.play()

func _process(_delta: float) -> void:
	if spawn_index < targets.size():
		if targets[spawn_index] - SPAWN_AHEAD_TIME <= rn.current_position:
			_spawn_visual_target()
			spawn_index += 1
	if current_target + MISS_THRESHOLD <= rn.current_position:
		_next_target()
  
func _compare(hit:float) -> bool:
	var difference = hit - current_target
	if abs(difference) <= MISS_THRESHOLD:
		return true
	return false

func _spawn_visual_target() -> void:
	var vt = visual_target.instantiate()
	vt.hit_time = targets[spawn_index]
	vt.notifier = rn
	vt.missed.connect(_on_target_missed)
	target_spawner.add_child(vt)
	visual_targets.append(vt)

func _on_target_missed(_target):
	score_tracker.change_score(-15)
	sfx_player.play()

func _next_target():
	if t_index < targets.size() -1:
		t_index += 1
		current_target = targets[t_index]

func _on_hammer_key_pressed() -> void:
	var hit:float = rn.current_position
	if _compare(hit):
		if is_instance_valid(visual_targets[t_index]):
			visual_targets[t_index].queue_free()
		anvil.throw_big_spark()
		score_tracker.change_score(+10)
	else:
		score_tracker.change_score(-5)

func _on_button_pressed() -> void:
	pass # 
