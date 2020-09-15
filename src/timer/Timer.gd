extends Node

onready var _label = get_node("Label")
onready var _start_time = OS.get_ticks_msec()

func _on_Timer_timeout() -> void:
	_label.text = "day %d" % (1 + floor((OS.get_ticks_msec() - _start_time) / 10000))
