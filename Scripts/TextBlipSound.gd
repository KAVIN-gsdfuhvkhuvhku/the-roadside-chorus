extends AudioStreamPlayer

const sounds : Dictionary = {
	"human": preload("res://assets/Sounds/human_type.wav"),
	"animal": preload("res://assets/Sounds/human_type.wav"),
	"??": preload("res://assets/Sounds/human_type.wav")
}

func play_sound(character_details: Dictionary):
	var character_type = character_details["type"]
	stream = sounds[character_type]
	play()
