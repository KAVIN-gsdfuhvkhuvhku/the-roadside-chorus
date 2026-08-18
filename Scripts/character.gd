#class_name Character
extends Node2D
@onready var sprite = $AnimatedSprite2D

const CHARACTER_FRAMES = {
	"You": preload("res://Resources/Protagonist_sprites.tres"),
	"Grandma": preload("res://Resources/Grandma_sprites.tres")
	}

func change_character(name: String, is_talking : bool = true):
	animated_sprite.sprite_frames = CHARACTER_FRAMES[name]
	if is_talking:
		animated_sprite.play("talking")
	e;se
