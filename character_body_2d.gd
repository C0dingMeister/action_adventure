extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var combo_step := 0
var combo_timer := 0.0
var max_combo_delay := 0.79  # time window to chain combos
var count = 0
var attack_anims = ["slash_down", "slash_up", "swing_attack"]

func _process(delta):
    if combo_timer > 0:
        combo_timer -= delta
        if combo_timer <= 0:
            reset_combo()

    if Input.is_action_just_pressed("attack"):
        handle_attack()

func handle_attack():
    count+=1
    print("attack pressed" + str(count))
    # if we are already in the middle of an attack, don't restart it
    if sprite.is_playing() and sprite.animation in attack_anims:
        return

    # play the current step
    var anim_name = attack_anims[combo_step]
    sprite.play(anim_name)

    # refresh combo timer
    combo_timer = max_combo_delay

func reset_combo():
    combo_step = 0
    sprite.play("idle")

func _on_animated_sprite_2d_animation_finished():
    # Only progress combo if the finished animation was an attack
    if sprite.animation in attack_anims:
        combo_step = (combo_step + 1) % attack_anims.size()
        # if no further input came during the attack, return to idle
        if combo_timer <= 0:
            reset_combo()
        #else:
            ## wait in "attack-ready" state until input continues
            #sprite.play("idle")
