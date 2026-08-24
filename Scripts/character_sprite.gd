extends Character
@onready var animated_sprite = $AnimatedSprite2D
#
#const CHARACTER_FRAMES = {
	#"You": preload("res://Resources/Protagonist_sprites.tres"),
	#"Grandma": preload("res://Resources/Grandma_sprites.tres")
	#}

func _ready():
	self.modulate.a = 0
	pass

func change_character(character_name : Character.Name, is_talking : bool, expression: String):
	var sprite_frames =  Character.CHARACTER_DETAILS[character_name]["sprite_frames"]
	var stance = "talking" if is_talking else "idle"
	var animation_name = expression + "-" + stance if expression else stance
	
	
#if the character has sprite frames, update the animated_sprite and play the animation
	if sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
		#Check if the associated animation expression exists and otehrwise play the idle version of it
		if animated_sprite.sprite_frames.has_animation(animation_name):
			animated_sprite.play(animation_name)
		else:
			animated_sprite.play(stance)
	else:
	#switch to the idle animation of the character currently displayed
		play_idle_animation()
		
	if self.modulate.a == 0:
		create_tween().tween_property(self, "modulate:a", 1.0, 0.3)

func play_idle_animation():
	var last_animation = animated_sprite.animation
	if last_animation and not last_animation.ends_with("-idle"):
		#if a custom expression is displaye dhere, try to find the matching idle animation
		#if it exists it should play but otherwise the normal one should play
		var idle_expression = last_animation.replace("talking", "idle")
		if animated_sprite.sprite_frames.has_animation(idle_expression):
			animated_sprite.play(idle_expression)
		else:
			animated_sprite.play("idle")
