extends Control

const THEME_PATH := "res://Resources/new_theme.tres"
const DIALOG_FONT_PATH := "res://assets/Fonts/VT323/VT323-Regular.ttf"

func _ready():
	# Resize the game window to match the player's screen size.
	var screen_size = DisplayServer.screen_get_size()
	get_window().size = screen_size
	apply_ui_theme()

	# Connect the menu buttons to their click functions.
	$CanvasLayer/MenuPanel/MenuContent/EasyButton.pressed.connect(_on_easy_pressed)
	$CanvasLayer/MenuPanel/MenuContent/HardButton.pressed.connect(_on_hard_pressed)

func apply_ui_theme():
	var game_theme := load(THEME_PATH) as Theme
	if game_theme:
		$CanvasLayer/MenuPanel.theme = game_theme

	var game_font := load(DIALOG_FONT_PATH) as FontFile
	if game_font:
		$CanvasLayer/MenuPanel/MenuContent/Title.add_theme_font_override("normal_font", game_font)
		$CanvasLayer/MenuPanel/MenuContent/Subtitle.add_theme_font_override("normal_font", game_font)
		$CanvasLayer/MenuPanel/MenuContent/EasyButton.add_theme_font_override("font", game_font)
		$CanvasLayer/MenuPanel/MenuContent/HardButton.add_theme_font_override("font", game_font)

func _on_easy_pressed():
	launch_game(3)

func _on_hard_pressed():
	launch_game(4)

func launch_game(size: int):
	# Store the selected difficulty so the main scene can read it.
	GameState.grid_size = size
	# Start the puzzle scene.
	get_tree().change_scene_to_file("res://Imported/HabitatFragmentation/Scenes/main.tscn")
