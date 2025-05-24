extends CharacterBody2D

var damage
@export var speed = 500
@export var level = 1
@export var reload_time = 0.5
func _ready() -> void:
	$AnimationPlayer.play("moving")
	$LaserSound.play()
	# Apply the initial level properties immediately in _ready
	laser_level(level)

func _physics_process(delta):
	# Use velocity directly for movement
	position += velocity * delta

func laser_level(level_value: int) -> void:
	# Store the level value
	level = level_value
	
	match level:
		1:
			$Laser.texture = load("res://graphics/Ship/BlueLaser1.png")
			damage = 5
			speed = 500
			
		2:
			$Laser.texture = load("res://graphics/Ship/BlueLaser2.png")
			damage = 7
			speed = 700
			
		3:
			$Laser.texture = load("res://graphics/Ship/BlueLaser3.png")
			damage = 10
			speed = 1000
			reload_time = 0.3
	
	# Update velocity based on the new speed
	# Note: This assumes velocity already has direction and we're just adjusting magnitude
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed

func get_damage() -> int:
	return damage

# Called when the laser hits something
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
