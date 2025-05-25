extends CharacterBody2D

# Export variables for inspector configuration
@export var laser: PackedScene
@export var max_speed := 250.0
@export var acceleration := 160.0
@export var friction := 40.0
@export var max_rotation_speed := 3.0
@export var steering_factor := 3.0
@export var fuel_node_path: NodePath

@export var inv: Inventory

# Constants
const MAX_FUEL := 100.0
const MAX_LASER_LEVEL := 3

# Ship properties
var current_rotation_velocity := 0.0
var engine_running := false
var can_shoot := true
var current_laser_level := 1
var ammo := 100
var can_move = true

# Fuel properties
var fuel_node
var fuel_amount := 30.0
var fuel_loss := 1.0
var fuel_gain := 0.5

func _ready() -> void:
	initialize_fuel()

func _process(delta: float) -> void:
	
	print()
	
	if can_move:
		update_rotation(delta)
		handle_movement(delta)
		position += velocity * delta
		handle_shooting()
	
	# Debug laser level increase (for testing only)
	if Input.is_action_just_pressed("ui_up"):
		increase_laser_level()

# Core gameplay functions
func update_rotation(delta: float) -> void:
	# Smoothly approach the desired rotation velocity
	current_rotation_velocity = move_toward(
		current_rotation_velocity, 
		get_desired_rotation_velocity(), 
		max_rotation_speed * delta
	)
	
	# Apply rotation with limited speed
	global_rotation += current_rotation_velocity * delta
	global_rotation = wrapf(global_rotation, -PI, PI)

func handle_movement(delta: float) -> void:
	# Engine control logic
	if Input.is_action_just_pressed("Fly") and has_fuel():
		engine_start()
	elif Input.is_action_pressed("Fly") and engine_running and has_fuel():
		apply_thrust(delta)
	elif Input.is_action_just_released("Fly"):
		stop_engine()
	else:
		apply_friction(delta)
		regenerate_fuel(delta)
	
	# Limit speed
	if velocity.length() >= max_speed:
		velocity = velocity.normalized() * max_speed

func handle_shooting() -> void:
	if can_shoot and ammo > 0 and Input.is_action_pressed("Shoot"):
		shoot()
		ammo -= 1

# Movement helper functions
func apply_thrust(delta: float) -> void:
	var facing_direction = Vector2.RIGHT.rotated(global_rotation)
	velocity += facing_direction * acceleration * delta
	
	# Consume fuel
	fuel_amount -= fuel_loss * delta
	if fuel_amount <= 0:
		fuel_amount = 0
		stop_engine()
	
	update_fuel_display()

func apply_friction(delta: float) -> void:
	if velocity.length() > 0:
		var friction_force = friction * delta
		if friction_force >= velocity.length():
			velocity = Vector2.ZERO
		else:
			velocity -= velocity.normalized() * friction_force

func get_desired_rotation_velocity() -> float:
	# Get direction to mouse
	var direction_to_mouse = get_global_mouse_position() - global_position
	var target_angle = direction_to_mouse.angle()
	
	# Calculate angle difference (shortest path)
	var angle_diff = wrapf(target_angle - global_rotation, -PI, PI)
	
	# Calculate and limit desired rotation velocity
	return clamp(angle_diff * steering_factor, -max_rotation_speed, max_rotation_speed)

# Engine functions
func engine_start() -> void:
	if has_fuel():
		engine_running = true
		$EngineAnim.play("fly_start")
		$EngineAnim.queue("fly")
		$EngineSound.play()

func stop_engine() -> void:
	engine_running = false
	$EngineAnim.play("fly_stop")
	$EngineSound.stop()

# Fuel functions
func initialize_fuel() -> void:
	if not fuel_node_path.is_empty():
		fuel_node = get_node(fuel_node_path)
		update_fuel_display()
	else:
		push_warning("Fuel node path not set in ship script")

func has_fuel() -> bool:
	return fuel_amount > 0

func regenerate_fuel(delta: float) -> void:
	if not engine_running and fuel_amount < MAX_FUEL:
		fuel_amount = min(fuel_amount + fuel_gain * delta, MAX_FUEL)
		update_fuel_display()

func update_fuel_display() -> void:
	$"../UI/HUD/Fuel".value = fuel_amount

# Weapon functions
func increase_laser_level() -> void:
	current_laser_level = current_laser_level % MAX_LASER_LEVEL + 1
	print("Laser level increased to: ", current_laser_level)

func shoot() -> void:
	var laser_instance = laser.instantiate()
	laser_instance.global_transform = global_transform

	# Direction the ship is facing
	var facing_direction = Vector2.RIGHT.rotated(global_rotation)
	
	# Set initial velocity direction
	laser_instance.velocity = facing_direction
	
	# Set the laser level
	laser_instance.level = current_laser_level
	
	# Add to scene
	get_parent().add_child(laser_instance)
	
	# Apply laser level properties
	laser_instance.laser_level(current_laser_level)
	
	# Apply ship's velocity to laser
	laser_instance.velocity += velocity
	
	# Handle shooting cooldown
	can_shoot = false
	await get_tree().create_timer(laser_instance.reload_time).timeout
	can_shoot = true

func pickup(item):
	inv.insert(item)
	
