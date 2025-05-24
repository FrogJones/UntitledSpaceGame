extends Control

@onready var inv: Inventory = preload("res://inventory/PlayerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false
var ship
var HUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	ship = get_tree().get_first_node_in_group("Ship")
	HUD = get_tree().get_first_node_in_group("HUD")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tab"):
		if is_open:
			is_open = false
			show_viewport()
		else:
			open()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func open() -> void:
	self.visible = true
	is_open = true
	clear_viewport()

func clear_viewport() -> void:
	ship.visible = false
	ship.can_shoot = false
	ship.can_move = false
	ship.velocity = Vector2.ZERO
	ship.current_rotation_velocity = 0.0
	HUD.visible = false
	$"../../Shadow".visible = true

func show_viewport() -> void:
	ship.visible = true
	ship.can_shoot = true
	ship.can_move = true
	HUD.visible = true
	$"../../Shadow".visible = false
	
