extends RigidBody2D


func _on_CompleteEnd_body_entered(body):
	if body.is_in_group('player'):
		Global.unlockedLevels += 1
		get_tree().change_scene("res://Menus/EndingMenu.tscn")
