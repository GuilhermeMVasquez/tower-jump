extends CanvasLayer

var time: float = 0.0
var sec: int = 0
var min: int = 0
var hrs: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	sec = fmod(time, 60)
	min = fmod(time, 3600) / 60
	hrs = fmod(time, 216000) / 3600
	$Panel/Hr.text = "%02d:" % hrs
	$Panel/Min.text = "%02d:" % min
	$Panel/Sec.text = "%02d" % sec

	
func stop() -> void:
	set_process(false)

func get_time_formatted() -> String:
	return "%02d:%02d:%02d" % [hrs, min, sec]
