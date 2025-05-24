extends Panel

@export var ship_node_path: NodePath
var ship

func _ready() -> void:
	ship = get_node(ship_node_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$AmmoText.text = "Ammo: " + str(ship.ammo) + "/100"
