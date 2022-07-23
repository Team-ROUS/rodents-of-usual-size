extends RigidBody2D


var occupied = false

func _on_Finish_body_entered(body):
	if body.is_in_group('player'):
		occupied = true
		get_tree().change_scene("res://Menus/GameMenu.tscn")
