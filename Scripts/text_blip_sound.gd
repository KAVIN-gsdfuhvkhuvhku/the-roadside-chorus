extends AudioStreamPlayer

const sounds : Dictionary = {
	"human": preload("res://assets/Sounds/audiomass-output.wav")
}

func play_sound(character_details: Dictionary):
	var character_type = character_details["type"]
	stream = sounds[character_type]
	play()
