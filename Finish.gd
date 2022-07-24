extends RigidBody2D


func _on_Finish_body_entered(body):
	if body.is_in_group('player'):
		Global.unlockedLevels += 1
		Global.prevScene = get_tree().get_current_scene().get_name()
		get_tree().change_scene("res://Menus/SuccessMenu.tscn")
