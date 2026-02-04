extends Resource
class_name Target

var expected_input:int
var tick:int

func _init(_expected_input:int, _tick:int ) -> void:
	expected_input = _expected_input
	tick = _tick

func _to_string() -> String:
	return str(expected_input) + ", " + str(tick)
