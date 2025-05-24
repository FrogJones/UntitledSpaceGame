extends Node2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# Get postiton of the ship
	var pos = $"../Ship".position
	
	# Calculate RGB values based on sinusoidal functions of position vector
	var r = clamp(sin(pos.x * 0.0002) * 0.3 + 0.3, 0.1, 0.35)
	var g = sin(pos.x * 0.0001) * 0.2 + cos(pos.y * 0.0001) * 0.1
	var b = clamp(cos(pos.y * 0.0002) * 0.4 + 0.3, 0.1, 0.65)
	var color_vec = Vector3(r, g, b)
	
	# Pass calculated value to VisualShader for further transformation
	var cloud_color := $ParallaxBackground/ParallaxLayer/ColorRect.material as ShaderMaterial
	cloud_color.set_shader_parameter("bg_color", color_vec)
	
	$ParallaxBackground/Background.motion_mirroring = get_viewport().size
	$ParallaxBackground/ParallaxLayer.motion_mirroring = get_viewport().size
	$ParallaxBackground/ParallaxLayer2.motion_mirroring = get_viewport().size
