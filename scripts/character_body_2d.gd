extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var combo_step := 0
var combo_timer := 0.0
var max_combo_delay := 0.6 # time window to chain combos
var count = 0
var attack_anims = ["slash_down", "slash_up", "swing_attack"]
var next_attack_queued := false
var run_speed = 200
var is_attacking = false
var gravity: float = 1300.0
var jump_speed: float = -500.0
var in_air = false

func _physics_process(delta: float) -> void:
    # --- Gravity ---
    if not is_on_floor():
        velocity.y += gravity * delta
        in_air = true
    else:
        velocity.y = 0
        in_air = false
    # --- attack animation ----
    if combo_timer > 0: 
        combo_timer -= delta 
        if combo_timer <= 0: 
            reset_combo()
    if Input.is_action_just_pressed("attack"): 
        handle_attack()
    # --- Jump ---
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_speed
        in_air = true
        sprite.play("jump_up")
    # --- Horizontal movement ---
    var direction = 0
    if Input.is_action_pressed("move_right") and not is_attacking:
        direction += 1
        sprite.flip_h = false
    if Input.is_action_pressed("move_left") and not is_attacking:
        direction -= 1
        sprite.flip_h = true

    velocity.x = direction * run_speed

    # --- Animations ---
    if velocity.y > 0 and in_air:
         sprite.play("falling")  
    
    if direction != 0 and not in_air:
        sprite.play("running_with_sword")
    elif !in_air and !is_attacking:
        sprite.play("idle")
      # going down
    # --- Apply movement ---
    move_and_slide()
    
func handle_movement(delta, flip):
    if flip:
        velocity.x -= delta * run_speed
        sprite.flip_h = true
    else:
        velocity.x += delta * run_speed
        sprite.flip_h = false
    sprite.play("running_with_sword")
    

func handle_attack():
    if sprite.is_playing() and sprite.animation in attack_anims:
        next_attack_queued = true
        return
    play_ground_combo_attack()

func play_ground_combo_attack():
    if not in_air:  
        is_attacking = true
        var anim_name = attack_anims[combo_step]
        sprite.play(anim_name)
        combo_timer = max_combo_delay

func reset_combo():
    combo_step = 0
    #sprite.play("idle")
    next_attack_queued = false
    is_attacking = false

func _on_animated_sprite_2d_animation_finished():
    if sprite.animation in attack_anims:
        if next_attack_queued and combo_timer > 0:
            combo_step = (combo_step + 1) % attack_anims.size()
            next_attack_queued = false
            play_ground_combo_attack()
        elif combo_timer > 0:
            # Await further input, don't reset combo yet
            pass
        else:
            reset_combo()
