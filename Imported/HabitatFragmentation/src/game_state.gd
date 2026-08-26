extends Node

# Shared setting used to tell the main scene whether to run 3x3 (easy) or 4x4 (hard).
var grid_size = 4
# Optional handoff file for returning to the Roadside Chorus story.
var return_story_dialog_file: String = ""
# Prevent relaunching Habitat after returning to the main story.
var habitat_completed: bool = false
