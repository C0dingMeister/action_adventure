extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var combo_step := 0
var combo_timer := 0.0
var max_combo_delay := 0.7 # time window to chain combos
var count = 0
var attack_anims = ["slash_down", "slash_up", "swing_attack"]
var next_attack_queued := false

func _process(delta):
    if combo_timer > 0:
        combo_timer -= delta
        if combo_timer <= 0:
            reset_combo()
    if Input.is_action_just_pressed("attack"):
        handle_attack()

func handle_attack():
    if sprite.is_playing() and sprite.animation in attack_anims:
        next_attack_queued = true
        return
    play_combo_attack()

func play_combo_attack():
    var anim_name = attack_anims[combo_step]
    sprite.play(anim_name)
    combo_timer = max_combo_delay

func reset_combo():
    combo_step = 0
    sprite.play("idle")
    next_attack_queued = false

func _on_animated_sprite_2d_animation_finished():
    if sprite.animation in attack_anims:
        if next_attack_queued and combo_timer > 0:
            combo_step = (combo_step + 1) % attack_anims.size()
            next_attack_queued = false
            play_combo_attack()
        elif combo_timer > 0:
            # Await further input, don't reset combo yet
            pass
        else:
            reset_combo()
