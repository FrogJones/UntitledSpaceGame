extends ParallaxBackground

@export var parallax_offset_multiplier := Vector2(0.1, 0.1)
@export var scroll_speed := Vector2.ZERO
@export var use_constant_scroll := false

var last_camera_position := Vector2.ZERO

func _ready():
	var camera := get_viewport().get_camera_2d()
	if camera:
		last_camera_position = camera.global_position

func _process(delta):
	var camera := get_viewport().get_camera_2d()
	if not camera:
		return

	var current_pos := camera.global_position
	var offset := (current_pos - last_camera_position) * parallax_offset_multiplier
	scroll_offset += offset
	last_camera_position = current_pos

	if use_constant_scroll:
		scroll_base_offset += scroll_speed * delta
