extends Node2D

@onready var new_game_button: Button = %NewGameButton
@onready var quit_button: Button = %QuitButton

func _ready():
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	SceneManager.transition_out_completed.connect(_on_transition_out_completed, CONNECT_ONE_SHOT)
	
func _on_new_game_button_pressed():
	SceneManager.transition_out()
	
func _on_transition_out_completed():
	SceneManager.change_scene("res://Scenes/main_scene.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit()
