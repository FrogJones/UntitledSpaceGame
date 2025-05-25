extends Panel

@export var ship_node_path: NodePath
var level = 1
var ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AmmoType/AmmoAnim.play("play")
	ship = get_node(ship_node_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_diplay()


func update_diplay() -> void:
	level = ship.current_laser_level
	
	match level:
		1:
			$AmmoType/Ammo.texture = load("res://graphics/Ship/BlueLaser1.png")
		2:
			$AmmoType/Ammo.texture = load("res://graphics/Ship/BlueLaser2.png")
		3:
			$AmmoType/Ammo.texture = load("res://graphics/Ship/BlueLaser3.png")
	
