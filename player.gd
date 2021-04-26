#
#This is a simple yet effective platform 2D controller. Since I'm just learning
#I'll play some more to learn how effectively make it easy and better.
#---------------------------------
#Cachal (Lucas Brill Lopes) - 26/04/2021
#
extends KinematicBody2D

export var VEL = 75
export var MAX_VEL = 125

export var ACCEL = 1.0
export var DEACCEL = 2.5

var MAX_FLOOR_ANGLE = 45.0

var JUMP = -300.0
const GRAVITY = 9.8

var velocity = Vector2()

onready var ground_detector = get_node("ground_detector")

#For now I don't need it.
func _ready():
	pass

func _physics_process(_delta):
	#cheks if the keys are pressed
	if !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		#these give a smooth transition when releasing the button
		if velocity.x > 0:
			velocity.x -= DEACCEL
		if velocity.x < 0:
			velocity.x += DEACCEL
	
	#the usual map input config with the direction values
	#giving a simple velocity condition to halt the player so he stays near the
	#maximum velocity
	if Input.is_action_pressed("left") and velocity.x > -MAX_VEL:
		#if velocity.x is 0 or lower, keep ACCEL
		if velocity.x <= 0:
			velocity.x -= ACCEL
		#if velocity.x is higher then use DEACCEL to help deaccellerate
		#this fix the changing direction deaccel problem
		if velocity.x > 0:
			velocity.x -= DEACCEL
	if Input.is_action_pressed("right") and velocity.x < MAX_VEL:
		if velocity.x >= 0:
			velocity.x += ACCEL
		if velocity.x < 0:
			velocity.x += DEACCEL
	
	#normalize and multiplies by VEL var.
	velocity.normalized().x = velocity.x * VEL

	#the jump action, always make sure you have a raycast to detect ground
	#collision.
	if ground_detector.is_colliding():
		if Input.is_action_just_pressed("action_jump"):
			velocity.y = JUMP
	
	#gravity works better if is constantly aplying
	if !ground_detector.is_colliding():
		velocity.y += GRAVITY
	
	#always make the velocity receive the move_and_slide with itself inside,
	#it makes the transition more smooth since it needs to calculate itself
	#every time.
	velocity = move_and_slide_with_snap(velocity,Vector2(0,2),Vector2.UP,true,
		4, MAX_FLOOR_ANGLE)
	
	pass
