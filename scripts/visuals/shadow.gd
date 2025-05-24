extends ColorRect

var max_alpha := 170.0 / 255.0  # Normalize to 0.0 - 1.0
var speed := 8.0
var target_a := 0.0

func _ready() -> void:
	target_a = 0.0
	modulate.a = 0.0  # Start transparent

func _process(delta: float) -> void:
	# Determine target alpha
	target_a = max_alpha if $"../HBoxContainer2/InvUI".is_open else 0.0

	# Easing factor
	var t := 1.0 - pow(1.0 - speed * delta, 2)

	# Calculate new eased alpha
	color.a = lerp(color.a, target_a, t)

	# Set the updated color with eased alpha
	modulate.a = color.a
