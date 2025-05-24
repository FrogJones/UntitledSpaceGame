extends Panel

@export var ship_node_path: NodePath
var level = 1
var ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("play")
	ship = get_node(ship_node_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_diplay()


func update_diplay() -> void:
	level = ship.current_laser_level
	
	match level:
		1:
			$Sprite2D.texture = load("res://graphics/Ship/BlueLaser1.png")
		2:
			$Sprite2D.texture = load("res://graphics/Ship/BlueLaser2.png")
		3:
			$Sprite2D.texture = load("res://graphics/Ship/BlueLaser3.png")
	
