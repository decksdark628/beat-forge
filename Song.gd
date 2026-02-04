extends Resource
class_name Song

var name:String
var bpm:int
var targets:Array = []

func add_target(exp_key:int, tick:int):
	var nuevo:Target = Target.new(exp_key, tick)
	targets.append(nuevo)

func _to_string() -> String:
	var temp:String = "SONG: %s - BPM: %d\n" % [name, bpm]
	for x in targets:
		temp += "\n" + x._to_string()
	
	return temp
