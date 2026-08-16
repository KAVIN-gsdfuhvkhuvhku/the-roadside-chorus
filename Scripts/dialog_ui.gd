extends Control

signal text_animation_done

@onready var dialog_line = %DialogLine
@onready var speaker_name = %SpeakerName

const ANIMATION_SPEED : int = 30
var animate_text : bool = false
var current_visible_characters : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if animate_text:
		if dialog_line.visible_ratio < 1:
			dialog_line.visible_ratio += (1.0/dialog_line.text.length()) * (ANIMATION_SPEED * delta)
			current_visible_characters = dialog_line.visible_characters
		else:
			animate_text = false
			text_animation_done.emit()

func change_line(speaker: String, line: String):
	speaker_name.text = speaker
	current_visible_characters = 0
	dialog_line.text = line
	dialog_line.visible_characters = 0
	animate_text = true
	
func skip_text_animation():
	dialog_line.visible_ratio = 1
