class_name Character
extends Node2D
@onready var animated_sprite = $AnimatedSprite2D

const CHARACTER_FRAMES = {
	"You": preload("res://Resources/Protagonist_sprites.tres"),
	"Grandma": preload("res://Resources/Grandma_sprites.tres")
	}

func _ready():
	pass

func change_character(name : String, is_talking : bool = true):
	animated_sprite.sprite_frames = CHARACTER_FRAMES[name]
	if is_talking:
		animated_sprite.play("talking")
	else:
		animated_sprite.play("idle")
		
func play_idle_animation():
	animated_sprite.play("idle")
