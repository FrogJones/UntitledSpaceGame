extends CharacterBody2D

func _physics_process(delta):
	position += velocity * delta
