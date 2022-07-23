extends AnimatedSprite

func _ready():
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	self.visible = false
