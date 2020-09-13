extends Node2D

onready var _eat_zone = get_node("EatZone")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
