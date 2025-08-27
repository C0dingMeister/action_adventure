extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var flip =false
var player = false


func _ready() -> void:
	print(1)
	
func _physics_process(delta):
	if player and player is CharacterBody2D:
		if player.global_position.x < global_position.x:
			sprite.flip_h = true
			sprite.offset.x = -20   # face left
		else:
			sprite.flip_h = false
			sprite.offset.x = 20  # face right

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	player = false
