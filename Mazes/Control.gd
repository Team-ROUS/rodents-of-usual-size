extends Control

export (int) var minutes = 0
export (int) var seconds = 0
var dsecs = 0

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if seconds > 0 and dsecs <= 0:
		seconds -= 1
		dsecs = 10
	if minutes > 0 and seconds <= 0:
		minutes -= 1
		seconds = 60
		
	$minute.set_text(str(minutes))	
	if seconds >= 10:
		$second.set_text(str(seconds))
	else:
		$second.set_text("0" + str(seconds))
	if dsecs >= 10:
		$dsec.set_text(str(dsecs))
	else:
		$dsec.set_text("0" + str(dsecs))

func _on_Timer_timeout():
	dsecs -= 1

