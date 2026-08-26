extends Node2D

@onready var new_game_button: Button = %NewGameButton
@onready var quit_button: Button = %QuitButton
const MAIN_SCENE_PATH := "res://Scenes/Main_scene.tscn"

func _ready():
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	SceneManager.transition_out_completed.connect(_on_transition_out_completed, CONNECT_ONE_SHOT)
	# Quit does nothing in a browser — hide the button on web builds.
	if OS.get_name() == "Web":
		quit_button.hide()
	
func _on_new_game_button_pressed():
	SceneManager.transition_out()
	
func _on_transition_out_completed():
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)
	
func _on_quit_button_pressed():
	get_tree().quit()
