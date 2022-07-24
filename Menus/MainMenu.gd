extends Control


func _on_StartButton_pressed():
	Global.prevScene = get_tree().get_current_scene().get_name()
	get_tree().change_scene("res://Menus/LevelMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://Menus/Credits.tscn")
