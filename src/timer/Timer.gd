extends Node

onready var _label = get_node("RichTextLabel")

func _on_Timer_timeout() -> void:
	_label.text = "day %d" % (1 + floor(OS.get_ticks_msec() / 10000))
