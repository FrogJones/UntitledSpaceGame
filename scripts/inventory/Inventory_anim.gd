extends NinePatchRect

const OPEN_X = -250
const CLOSED_X = 0
const SPEED = 8.0  # Higher = faster

var parent_node
var target_x: float

func _ready() -> void:
	parent_node = get_parent()
	target_x = CLOSED_X

func _process(delta: float) -> void:
	# Set target position based on open state
	target_x = OPEN_X if parent_node.is_open else CLOSED_X

	# Smoothly move toward target using easing
	var t := 1.0 - pow(1.0 - SPEED * delta, 2)  # Easing factor
	position.x = lerp(position.x, target_x, t)
