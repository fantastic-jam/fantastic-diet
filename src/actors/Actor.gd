extends KinematicBody2D
class_name Actor

func _process(__delta: float) -> void:
	z_index = int(position.y)

func play_sound(sound_player_name: NodePath, sound: AudioStream) -> void:
	var player = get_node(sound_player_name) as AudioStreamPlayer
	player.stream = sound
	player.play()

func spawn_object(obj) -> Node:
	var instance := obj.instance() as Node;
	get_parent().add_child(instance)
	return instance
