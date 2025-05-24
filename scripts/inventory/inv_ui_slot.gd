extends Panel

@onready var item_visuals: Sprite2D = $ItemDisplay
@onready var amount: Label = $Label

func _process(_delta: float) -> void:
	pass

func update(slot: InvSlot):
	if !slot.item:
		item_visuals.visible = false
		amount.visible = false
	else:
		item_visuals.visible = true
		item_visuals.texture = slot.item.texture
		amount.text = str(slot.amount)
		if slot.amount > 1:
			amount.visible = true
