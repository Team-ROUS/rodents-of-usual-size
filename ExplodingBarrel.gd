extends RigidBody2D

func _ready():
	pass # Replace with function body.

func _on_ExplodingBarrel_body_entered(body):
	if body.is_in_group("player"):
		$AnimatedSprite.visible = true
		$AnimatedSprite.play("explode")
		$Sprite.visible = false
