extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var velocity = Vector2(500, 500)
func _physics_process(delta):
	$KinematicBody2D.move_and_slide(velocity)
	if $KinematicBody2D.position.x > get_viewport().size.x:
		velocity.x *= -1
	if $KinematicBody2D.position.y > get_viewport().size.y:
		velocity.y *= -1
	if $KinematicBody2D.position.x < 0:
		velocity.x *= -1
	if $KinematicBody2D.position.y < 0:
		velocity.y *= -1

