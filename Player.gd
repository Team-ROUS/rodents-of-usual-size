extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 25
const MAXFALLSPEED = 400
const MAXSPEED = 200
export(int) var JUMPFORCE = 400
export(int) var ACCEL = 30
const AIRMULTIPLIERCONTROLS = 0.7
const AIRMULTIPLERX = 0.1
const FacingX = {LEFT = -1, RIGHT = 1}

var motion = Vector2()
var direction: float = 1.0
var facingX = FacingX.RIGHT
 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.

func get_motion_multiplier():
	if not is_on_floor() and not is_on_wall():
		return AIRMULTIPLIERCONTROLS
	return 1.0

func handle_gravity():
	if not is_on_wall():
		motion.y += GRAVITY
	else:
		motion.x += (GRAVITY * is_near_wall())

func handle_terminal_velocity():
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

func handle_facing_x():
	if Input.is_action_pressed("right"):
		facingX = FacingX.RIGHT
	if Input.is_action_pressed("left"):
		facingX = FacingX.LEFT

func get_direction():
	if Input.is_action_pressed("right"):
		return 1
	if Input.is_action_pressed("left"):
		return -1
	return 0

func get_move_axis():
	if is_on_floor():
		return "x"
	if is_on_wall():
		return "y"
	return "x"

func _physics_process(delta):
	handle_gravity()
	handle_terminal_velocity()
	handle_facing_x()
	rotate_mouse()
	
	direction = get_direction()
	var move_axis = get_move_axis()

	if move_axis == "y":
		motion[move_axis] += (ACCEL * direction * -is_near_wall() * get_motion_multiplier())
	else:
		motion[move_axis] += (ACCEL * direction  * get_motion_multiplier())

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
	if is_on_wall():
		motion.y = clamp(motion.y, -MAXSPEED, MAXSPEED)
		if get_direction() == 0:
			motion.y = lerp(motion.y, 0, 0.2)
		if Input.is_action_just_pressed("jump"):
			motion.x = JUMPFORCE * -is_near_wall()
			motion.y = -JUMPFORCE
		if Input.is_action_just_pressed("down"):
			motion.x = JUMPFORCE * -is_near_wall()
	if get_direction() == 0:
		motion.x = lerp(motion.x, 0, 0.2)
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	motion = move_and_slide(motion, UP)
	
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene("res://Menus/GameMenu.tscn");
	
	


func is_near_wall():
	if $Wallcheckerfront.is_colliding():
		return 1
	if $Wallcheckerback.is_colliding():
		return -1
	else:
		return 0


func rotate_mouse():
	$Sprite.scale.x *= facingX

	if is_near_wall() == -1:
		$Sprite.rotation_degrees = -90 * facingX
	if  is_near_wall() == 0:
		$Sprite.rotation_degrees = 0
	if  is_near_wall() == 1:
		$Sprite.rotation_degrees = 90 * facingX
