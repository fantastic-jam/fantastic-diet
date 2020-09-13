extends Actor

export var device = "0"
export var speed = 200

var _is_in_eat_zone = false
var _eat_zone: Area2D = null
var _shouting = false
var _last_shout = 0
var _shout_cooldown = 1000

onready var _animation_player = get_node("AnimationPlayer")
onready var _sprite = get_node("Sprite")
onready var _hunger_bar = get_node("HungerBarNode/HungerBar")
onready var _hey_bubble = get_node("HeyBubble")
var _hey_sounds = []
var _hey_sound_num = 6
var _eat_sound = preload("res://assets/snd/bruno/nom.ogg")
onready var _shout_area = get_node("ShoutArea")
onready var _root = get_tree().current_scene 

var _hunger = 100
var _hunger_decay = 7.8
var _food_value = 5

func _ready() -> void:
	_hey_bubble.visible = false
	for i in range(_hey_sound_num):
		var sound = "res://assets/snd/bruno/hey-%02d.ogg" % (i + 1)
		print(sound)
		_hey_sounds.append(load(sound))


func _process(delta: float) -> void:
	update_hunger(_hunger - (_hunger_decay * delta))
	if _hunger < 0:
		_root.game_over()
		queue_free()
	if _shouting:
		var now = OS.get_ticks_msec()
		if now > (_last_shout + _shout_cooldown):
			_shouting = false
			_hey_bubble.visible = false
			_shout_area.monitoring = false

func _physics_process(delta: float) -> void:
	var direction: = Vector2(
		(Input.get_action_strength(	"move_right_" + device) - Input.get_action_strength("move_left_" + device)) * speed,
		(Input.get_action_strength("move_down_" + device) - Input.get_action_strength("move_up_" + device)) * speed / 2
	)
	if direction.x != 0:
		_sprite.flip_h = (direction.x < 0)
		
	if direction == Vector2.ZERO:
		_animation_player.stop()
	else:
		_animation_player.play("Walk")

	move_and_slide(direction)

	if Input.is_action_just_pressed("eat_0") && _is_in_eat_zone:
		eat()
	if Input.is_action_just_pressed("shout_0") && !_shouting:
		shout()
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider.has_method('eat'):
#			collision.collider.eat()
#			break

func update_hunger(value: float) -> void:
	_hunger = value
	_hunger_bar.value = _hunger

func _on_eat_zone_entered(eat_zone: Area2D) -> void:
	_is_in_eat_zone = true
	_eat_zone = eat_zone
	
func _on_eat_zone_exited(eat_zone: Area2D) -> void:
	_is_in_eat_zone = false
	_eat_zone = null
	
func eat() -> void:
	var eaten = _eat_zone.eat()
	if eaten:
		play_sound("Speech", _eat_sound)
		update_hunger(_hunger + _food_value)

func shout() -> void:
	var now = OS.get_ticks_msec()
	if now > (_last_shout + _shout_cooldown):
		_shouting = true
		_last_shout = now
		_hey_bubble.visible = true
		_shout_area.monitoring = true
		play_sound("Speech", _hey_sounds[randi() % _hey_sound_num])

func _on_ShoutArea_body_entered(body: Node) -> void:
	if body.has_method("on_shouted_on"):
		body.on_shouted_on(self)
