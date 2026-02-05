extends Node2D

const NUM_POOLED_V_TARGETS:int = 2

@export var target_scene:PackedScene
var v_targets:Array = []
var current:Node2D
var tracker:int = 0

func _ready() -> void:
	for i in range(0, NUM_POOLED_V_TARGETS):
		var vt:Node2D = target_scene.instantiate()
		v_targets.append(vt)
		add_child(vt)
	current = v_targets[0]

func peek_next_v_target() -> Node2D:
	var n = tracker + 1
	if n >= NUM_POOLED_V_TARGETS:
		n = 0
	return v_targets[n]

func next_v_target() -> void:
	tracker += 1
	if tracker >= NUM_POOLED_V_TARGETS:
		tracker = 0
	current = v_targets[tracker]
