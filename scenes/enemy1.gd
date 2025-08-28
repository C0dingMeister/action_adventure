extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var flip =false
var player = false
var gravity: float = 1300.0
var stop_distance := 55
var max_speed := 50.0
var accel := 600.0
var target_speed := 0.0
var attack_range_x: float = 50
var attack_sprite = ["attack1", "attack2"]
var attack_animation = false
var can_walk = true


func _ready() -> void:
	pass

func _physics_process(delta):
	
	#Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	#flip towards player and walk part
	
	if player and player is CharacterBody2D:
		var dx : float = player.global_position.x - global_position.x
		
		#flip
		if player.global_position.x < global_position.x:
			sprite.flip_h = true
			sprite.offset.x = -20   # face left
		else:
			sprite.flip_h = false
			sprite.offset.x = 20  # face right
	# Attack and walk
		var Xrange = absf(dx) < attack_range_x
		if !Xrange and attack_animation == false and can_walk:
				target_speed = sign(dx) * max_speed
				sprite.play("walk")
		else:
			target_speed = 0
			if attack_animation == false:
				can_walk = false
				if !Xrange:
					can_walk = true
				attack_animation = true
				var a_s = randi_range(0,1)
				sprite.play(attack_sprite[a_s])
				
		print(velocity.x)
		velocity.x = move_toward(velocity.x, target_speed, accel * delta)
		print(velocity.x)
	move_and_slide()


func _on_trigger_body_entered(body: Node2D) -> void:
	player = body


func _on_animated_sprite_2d_animation_finished() -> void:
	attack_animation = false
	sprite.play("idle")
	pass # Replace with function body.
