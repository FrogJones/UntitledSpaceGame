extends Area2D
@export var item: InvItem
var player = null

func _ready():
	body_entered.connect(_on_interactable_area_body_entered)

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		$sound.play()
		player = body
		player.pickup(item)
		await $sound.finished
		self.queue_free()
