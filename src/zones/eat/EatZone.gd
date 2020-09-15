extends Area2D

export var pizza_count = 0
export var eat_bar = 100

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	update_pizza_count(pizza_count)
	update_eat_bar(eat_bar)

func eat() -> bool:
	if pizza_count == 0:
		return false
	if eat_bar > 0:
		update_eat_bar(eat_bar - 5)
	if eat_bar <= 0:
		update_pizza_count(pizza_count - 1)
		if pizza_count > 0:
			update_eat_bar(100)
	return true

func drop_pizza() -> void:
	update_pizza_count(pizza_count + 1)

func update_eat_bar(value):
	eat_bar = value
	find_node("ProgressBar").value = eat_bar

func update_pizza_count(value):
	pizza_count = value
	if pizza_count > 0 :
		if eat_bar == 0:
			update_eat_bar(100)
		find_node("Sprite").visible = true
		find_node("CountLabel").text = String(pizza_count)
	else:
		find_node("Sprite").visible = false
		find_node("CountLabel").text = ""
	

func _on_EatZone_body_entered(body: Node) -> void:
	if body.has_method("_on_eat_zone_entered"):
		body._on_eat_zone_entered(self)

func _on_EatZone_body_exited(body: Node) -> void:
	if body.has_method("_on_eat_zone_exited"):
		body._on_eat_zone_exited(self)
		
func get_pizza_location() -> Vector2:
	return get_node("Sprite").global_position
