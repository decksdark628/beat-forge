extends Node2D

const TEST_SONG_PATH:String = "res://song_data/song_00-120bpm.csv"

@onready var rn: RhythmNotifier = $RhythmNotifier
@onready var importer: Node = $SongImporter
@onready var player: AudioStreamPlayer = $SongPlayer

func _ready() -> void:
	importer.import_song(TEST_SONG_PATH)
	rn.bpm = importer.song.bpm

func start_game():
	rn.beats()
	rn.audio_stream_player.play()
