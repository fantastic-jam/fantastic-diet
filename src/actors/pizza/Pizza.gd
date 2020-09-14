extends Node2D
class_name Pizza

export var _destination: Vector2 = Vector2.ZERO
export var _speed: float = 200
 
onready var _sprite:Sprite = get_node("Sprite")
onready var _total_distance = (_destination - position).length()

var _creator:Node2D = null

var _origin: Vector2 = Vector2.ZERO
func _ready() -> void:
	_origin = position

func _physics_process(delta: float) -> void:
	if (_destination - position).length() < 5:
		position = _destination

		if _creator != null && _creator.has_method('on_pizza_destination_reached'):
			_creator.on_pizza_destination_reached(self)
		return
	travel_to_destination(delta)

func travel_to_destination(delta:float) -> void:
	var progression: float = get_travel_progression();
	var curve: float = get_travel_curve(progression);
	_sprite.scale = (2 + curve) * Vector2.ONE
	_sprite.offset.y = curve * -15;
	translate(position.direction_to(_destination) * _speed * delta);


func get_travel_progression() -> float:
	var remaining_distance: float = (position - _destination).length();
	return (_total_distance - remaining_distance) / _total_distance;

func get_travel_curve(progression:float) -> float:
	return (0.5 - abs(progression - 0.5)) * 2.0;
