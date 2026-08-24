extends Control

const THEME_PATH := "res://Resources/new_theme.tres"
const DIALOG_FONT_PATH := "res://assets/Fonts/VT323/VT323-Regular.ttf"

func _ready():
	apply_ui_theme()
	# Connect the end-screen buttons to their actions.
	$CanvasLayer/EndPanel/Content/PlayAgainButton.pressed.connect(_on_play_again_pressed)
	$CanvasLayer/EndPanel/Content/ExitButton.pressed.connect(_on_exit_pressed)

func apply_ui_theme():
	var game_theme := load(THEME_PATH) as Theme
	if game_theme:
		$CanvasLayer/EndPanel.theme = game_theme

	var game_font := load(DIALOG_FONT_PATH) as FontFile
	if game_font:
		$CanvasLayer/EndPanel/Content/Subtitle.add_theme_font_override("normal_font", game_font)
		$CanvasLayer/EndPanel/Content/PlayAgainButton.add_theme_font_override("font", game_font)
		$CanvasLayer/EndPanel/Content/ExitButton.add_theme_font_override("font", game_font)

func _on_play_again_pressed():
	# Return to the start menu to choose a mode again.
	get_tree().change_scene_to_file("res://Imported/HabitatFragmentation/Scenes/start_menu.tscn")

func _on_exit_pressed():
	# Return to Roadside Chorus and continue from scene eight.
	GameState.habitat_completed = true
	GameState.return_story_dialog_file = "res://Resources/story/eighth_scene.json"
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
