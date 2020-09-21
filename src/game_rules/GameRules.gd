extends Node2D

onready var _eat_zone = get_node("EatZone")

var _is_game_over = false

func _ready() -> void:
	pass

func drop_pizza(origin: Vector2) -> void:
	var pizza = preload("res://src/actors/pizza/Pizza.tscn").instance()
	pizza.position = origin
	pizza._creator = self
	pizza.z_index = 1002

	pizza._destination = _eat_zone.get_pizza_location()
	add_child(pizza);
	
func on_pizza_destination_reached(pizza: Pizza) -> void:
	pizza.queue_free()
	_eat_zone.drop_pizza()

func game_over() -> void:
	get_node("GameOver").visible = true
	get_node("Time/Timer").stop()
	_is_game_over = true

func _input(event: InputEvent) -> void:
	if _is_game_over and event.is_pressed() and not event.is_echo():
		if (event is InputEventKey
		or event is InputEventMouseButton
		or event is InputEventJoypadButton):
			var _result = get_tree().reload_current_scene()
