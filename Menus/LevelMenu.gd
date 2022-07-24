extends Control


func _ready():
	for i in range($Levels.get_child_count()):
		Global.levels.append(i+1)
		
	for level in $Levels.get_children():
		if str2var(level.name) in range(Global.unlockedLevels+1):
			level.disabled = false
			level.connect('pressed', self, 'level_button_pressed',
							[level.name])
		else:
			level.disabled = true

		
func level_button_pressed(levelNumber):
	Global.prevScene = get_tree().get_current_scene().get_name()
	get_tree().change_scene("res://Mazes/Maze" + levelNumber +".tscn")
