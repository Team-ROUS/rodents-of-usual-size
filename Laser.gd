tool
extends Node

const SERCOMM = preload("res://addons/GDSerCommDock/bin/GDSerComm.gdns")
onready var PORT = SERCOMM.new()

onready var com = $Com

func _ready():
	PORT.open(
		"/dev/cu.usbserial-120",
		9600,
		1000,
		com.bytesz.SER_BYTESZ_8, 
		com.parity.SER_PAR_NONE, 
		com.stopbyte.SER_STOPB_ONE)
	PORT.flush()

var maps = [
	"0,0,DRDDDDRRRRLLDD\n",
	"0,0,DRRRRRDRLLDDRD\n",
	"0,0,DDDRRRDRDRDRRL\n",
	"0,0,RRRRDDRLLLDDRL\n",
	"0,0,RRRDLRLDRLLDRL\n"
]
var map_idx = 0

func laser_set_map():
	PORT.write(maps[map_idx])
	PORT.flush()

func laser_change_map():
	map_idx += 1
	if map_idx >= len(maps):
		map_idx = 0
	laser_set_map()
