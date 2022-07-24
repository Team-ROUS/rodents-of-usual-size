extends Node2D

var page_counter : int = 1

onready var cut1 = $Cutscene1
onready var cut2 = $Cutscene2
onready var cut3 = $Cutscene3
onready var cut4 = $Cutscene4
onready var audiobit = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	page_counter = 1
	

func _process(_delta):
	#Detects player input.
	if Input.is_action_pressed("ui_accept"):
		if page_counter < 5:
			page_counter += 1
	#Switches cutscene sprites.
	match page_counter:
		_:
			cut1.visible = true
			cut2.visible = false
			cut3.visible = false
			cut4.visible = false
		2:
			cut1.visible = false
			cut2.visible = true
			cut3.visible = false
			cut4.visible = false
		3:
			cut1.visible = false
			cut2.visible = false
			cut3.visible = true
			cut4.visible = false
		4: 
			cut1.visible = false
			cut2.visible = false
			cut3.visible = false
			cut4.visible = true
			audiobit.play() #Should play this as well lol
#		5: changescene()

#func changescene():
#
