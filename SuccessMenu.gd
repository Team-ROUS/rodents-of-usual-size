extends Control


func _on_NextButton_pressed():
	var mazeNum = str(Global.prevScene).right(4);
	var nextLevel = int(mazeNum)+1
	get_tree().change_scene("res://Mazes/Maze" + str(nextLevel) +".tscn")


func _on_RestartButton_pressed():
	get_tree().change_scene("res://Mazes/" + str(Global.prevScene) +".tscn")


func _on_QuitButton_pressed():
	get_tree().change_scene("res://Menus/MainMenu.tscn")
