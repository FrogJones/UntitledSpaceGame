extends TextureProgressBar

var flashing = false
var timer = 0.0
var flash_interval = 0.5  # Time in seconds between flashes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Warning.visible = false  # Hide warning initially

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if warning condition is met
	if warning(value):
		if not flashing:
			flashing = true
			$Warning.visible = true
		
		# Handle flashing with timer
		timer += delta
		if timer >= flash_interval:
			timer = 0.0
			$Warning.visible = not $Warning.visible
	else:
		# No warning needed
		if flashing:
			flashing = false
			$Warning.visible = false
			timer = 0.0

func warning(fuel: float) -> bool:
	if fuel <= 10:
		return true
	else:
		return false
