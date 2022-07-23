extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 25
const MAXFALLSPEED = 400
const MAXSPEED = 200	
export(int) var JUMPFORCE  = 400
const ACCEL = 10
const AIRMULTIPLIERCONTROLS = 0.7
const AIRMULTIPLERX = 0.1

var motion = Vector2()
var direction = 1
var facingX = "right"
var facingY = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	print(direction)
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	rotate_mouse(facingX, facingY)
	$Wallcheckerfront.rotation_degrees = 90 * -direction
	$Wallcheckerfront.rotation_degrees = 90 * direction
	if is_near_wall() != 0:
		direction = is_near_wall()
	
#	if is_near_wall():
#		motion.x += ACCEL * direction

	var space = Input.get_action_strength("ui_select")
	if space > 0:
		$Laser.laser_change_map()
		
			
	if is_on_floor():
		facingY = "none"
	
	if not is_on_wall():
		facingY = "none"
		motion.y += GRAVITY
		if motion.y > MAXFALLSPEED:
			motion.y = MAXFALLSPEED
			
		if is_on_floor():
			if Input.is_action_pressed("right"):
				motion.x += ACCEL
				direction = 1
				facingX = "right"
			elif Input.is_action_pressed("left"):
				motion.x -= ACCEL
				direction = -1
				facingX = "left"
			else:
				motion.x = lerp(motion.x, 0, 0.2)
			if Input.is_action_just_pressed("jump"):
				motion.y = -JUMPFORCE
		else:
			if Input.is_action_pressed("right"):
				motion.x += ACCEL * AIRMULTIPLIERCONTROLS
				direction = 1
				facingX = "right"
			elif Input.is_action_pressed("left"):
				motion.x -= ACCEL * AIRMULTIPLIERCONTROLS
				direction = -1
				facingX = "left"
			else:
				motion.x = lerp(motion.x, 0, 0.2 * AIRMULTIPLERX)
			
		
	
	elif is_on_wall():
		if is_on_floor():
			if direction == -1:
				if Input.is_action_pressed("left"):
					motion.y = -ACCEL
				if Input.is_action_pressed("right"):
					motion.x = -ACCEL * direction
			elif direction == 1:
				if Input.is_action_pressed("right"):
					motion.y = -ACCEL
				if Input.is_action_pressed("left"):
					motion.x = -ACCEL * direction
		
		motion.y = clamp(motion.y, -MAXSPEED, MAXSPEED)
		if not is_on_floor():
			motion.x += GRAVITY * direction

		if Input.is_action_just_pressed("jump"):
			motion.x = -JUMPFORCE * direction
			motion.y = -JUMPFORCE
		elif Input.is_action_pressed("right"):
			if direction == 1:
				print("up")
				facingY = "up"
			elif direction == -1:
				facingY = "down"
				print("down")
			motion.y -= ACCEL * direction
		elif Input.is_action_just_pressed("left"):
			if direction == 1:
				facingY = "down"
				print("down")
			elif direction == -1:
				facingY = "up"
				print("up")
			motion.y += ACCEL * direction

		else:
			motion.y = lerp(motion.y, 0, 0.2)
			
			
			
	motion = move_and_slide(motion, UP)
	
	
func is_near_wall():
	if $Wallcheckerfront.is_colliding():
		return 1
	if $Wallcheckerback.is_colliding():
		return -1
	else:
		return 0
	
func rotate_mouse(x, y):
	$Sprite.scale.x = direction
	$CollisionShape2D.scale.x = direction
		
	if y == "up":
		$Sprite.rotation_degrees = -90 * direction
#		$CollisionShape2D.rotation_degrees = 180 * direction
		$Sprite.scale.y = 1
	elif y == "none":
		$Sprite.rotation_degrees = 0
#		$CollisionShape2D.rotation_degrees = 0
		$Sprite.scale.y = 1
	elif y == "down":
		$Sprite.rotation_degrees = 90 * direction
#		$CollisionShape2D.rotation_degrees = -180 * direction
		$Sprite.scale.y = -1
	$CollisionShape2D.rotation_degrees = $Sprite.rotation_degrees
