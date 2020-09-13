extends Actor

export var _device = "0"
export var _max_speed = 80
export var _direction = -1
export var _pizza = true

onready var _sprite = get_node("Sprite")
onready var _grunt_bubble = get_node("GruntBubble")
onready var _pizza_sprite = get_node("PizzaSprite")
onready var _root = get_node('/root/Root')

var regions = [
	Rect2(112, 224, 16, 16),
	Rect2(128, 224, 16, 16),
	Rect2(144, 224, 16, 16),
	Rect2(160, 224, 16, 16),
	Rect2(176, 224, 16, 16),
	Rect2(96, 240, 16, 16),
	Rect2(112, 240, 16, 16),
	Rect2(128, 240, 16, 16),
	Rect2(144, 240, 16, 16),
	Rect2(160, 240, 16, 16),
	Rect2(176, 240, 16, 16),
]

var _grunting = false
var _last_grunt = 0
var _grunt_cooldown = 1000

var _speed = _max_speed
var _speed_decay = 10
export var _min_speed = 5

func _ready() -> void:
	_grunt_bubble.visible = false
	_pizza_sprite.visible = _pizza
	random_skin()
	
func random_skin() -> void:
	_sprite.region_rect = regions[randi() % regions.size()]

func _process(delta: float) -> void:
	if _grunting:
		var now = OS.get_ticks_msec()
		if now > (_last_grunt + _grunt_cooldown):
			_grunting = false
			_grunt_bubble.visible = false
	_speed -= delta * _speed_decay
	if _speed < _min_speed:
		_speed = _min_speed

func _physics_process(delta: float) -> void:
	var velocity: = Vector2(
		_direction * _speed,
		0
	)
	move_and_slide(velocity, Vector2.UP)
	if position.x > 640 || position.x < 200:
		flip()

func flip():
	_direction = -_direction;
	_sprite.flip_h = _direction <= 0
	if _pizza:
		throw_pizza()
	else:
		random_skin()
	_pizza = !_pizza
	_pizza_sprite.visible = _pizza

func throw_pizza() -> void:
	_root.drop_pizza(get_node("PizzaSprite").global_position)

func on_shouted_on(shouter: Node2D) -> void:
	grunt()
	_speed += 10 + randi()%70+1
	if _speed > _max_speed:
		_speed = _max_speed

func grunt() -> void:
	var now = OS.get_ticks_msec()
	if now > (_last_grunt + _grunt_cooldown):
		_grunting = true
		_last_grunt = now
		_grunt_bubble.visible = true
