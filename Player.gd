extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var left = Input.get_action_strength("ui_left")
	var right = Input.get_action_strength("ui_right")
	var up = Input.get_action_strength("ui_up")
	var down = Input.get_action_strength("ui_down")

	var x = -left if left > 0 else right
	var y = -up if up > 0 else down
	$Player/KinematicBody2D.move_and_slide(Vector2(x * 100, y * 100))

