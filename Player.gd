extends KinematicBody2D

const UP = Vector2(0, -1)
export(int) var GRAVITY = 25
export(int) var WALLGRAVITY = 10
export(int) var MAXFALLSPEED = 400
export(int) var MAXSPEED = 100
export(int) var WALLJUMPFORCE = 200
export(int) var JUMPFORCE = 300
export(int) var WALLDROPFORCE = 100
export(int) var ACCEL = 15
export(float) var AIRMULTIPLIERCONTROLS = 0.7

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
		motion.x += (WALLGRAVITY * is_near_wall())


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
	animate_mouse()

	direction = get_direction()
	var move_axis = get_move_axis()
	if move_axis == "y":
		motion[move_axis] += (ACCEL * direction * -is_near_wall() * get_motion_multiplier())
	else:
		motion[move_axis] += (ACCEL * direction * get_motion_multiplier())

#	if Input.get_action_strength("ui_accept") > 0:
	$Laser.laser_update()

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
	if is_on_wall():
		motion.y = clamp(motion.y, -MAXSPEED, MAXSPEED)
		if get_direction() == 0:
			motion.y = lerp(motion.y, 0, 0.2)
		if Input.is_action_just_pressed("jump"):
			motion.x = WALLJUMPFORCE * -is_near_wall()
			motion.y = -WALLJUMPFORCE
		if Input.is_action_just_pressed("down"):
			motion.x = WALLDROPFORCE * -is_near_wall()
	if get_direction() == 0:
		motion.x = lerp(motion.x, 0, 0.2)
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	motion = move_and_slide(motion, UP)

#	show the pause menu
	if Input.is_action_just_pressed("pause"):
		Global.prevScene = get_tree().get_current_scene().get_name()
		get_tree().change_scene("res://Menus/GameMenu.tscn");
	
	


func is_near_wall():
	if $Wallcheckerfront.is_colliding():
		return 1
	if $Wallcheckerback.is_colliding():
		return -1
	else:
		return 0

func get_corner_inner_caster():
	if is_on_wall():
		if is_near_wall() == 1:
			if facingX == FacingX.LEFT:
				return $WallDistanceDown
			return $WallDistanceLeft
		if is_near_wall() == -1 :
			if facingX == FacingX.RIGHT:
				return $WallDistanceDown
			return $WallDistanceRight
	if facingX == FacingX.LEFT:
		return $WallDistanceLeft
	return $WallDistanceRight

func animate_mouse():
	$Sprite.animation = "moving"
	$Sprite.playing = true
	var caster = get_corner_inner_caster()
	if caster.is_colliding():
		#WallDistanceBack
		var origin = caster.global_transform.get_origin()
		var collision = caster.get_collision_point()
		var distance = origin.distance_to(collision)
		var upper = 8
		var lower = 4
		var num_frames = 3
		if distance < upper and distance > lower:
			var percentage = ((distance - lower) / (upper - lower))
			var framePercentage = percentage;
			if facingX == FacingX.LEFT or is_on_wall():
				framePercentage = 1 - percentage;
			var frame = round(framePercentage * num_frames)
			$Sprite.animation = "corner-inner"
			$Sprite.playing = false
			$Sprite.frame = frame

	$Sprite.scale.x = abs($Sprite.scale.x) * facingX
	$Sprite.rotation_degrees = 0
	if is_on_wall():
		$Sprite.rotation_degrees = 90 * -is_near_wall()
