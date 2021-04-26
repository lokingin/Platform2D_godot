#
#This is a simple yet effective platform 2D controller. Since I'm just learning
#I'll play some more to learn how effectively make it easy and better.
#---------------------------------
#Cachal (Lucas Brill Lopes) - 26/04/2021
#

extends KinematicBody2D

var VEL = 400
var MAX_VEL = 457 #todo

var MAX_FLOOR_ANGLE = 45.0

var JUMP = -300.0
const GRAVITY = 9.8

var velocity = Vector2()

onready var ground_detector = get_node("ground_detector")

func _ready():
	
	pass

func _physics_process(delta):
	#cheks if the keys are pressed
	if !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		#these give a smooth transition when releasing the button
		if velocity.x > 0:
			velocity.x -= 1.0
		if velocity.x < 0:
			velocity.x += 1.0
	
	#the usual map input config with the direction values
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
	if Input.is_action_pressed("right"):
		velocity.x += 1.0
	
	#normalize and multiplies by VEL var.
	velocity.normalized().x = velocity.x * VEL
	
	#the jump action, always make sure you have a raycast to detect ground
	#collision.
	if ground_detector.is_colliding():
		if Input.is_action_just_pressed("action_jump"):
			velocity.y = JUMP
	
	#gravity works better if is constantly aplying
	velocity.y += GRAVITY
	
	#always make the velocity receive the move_and_slide with itself inside,
	#it makes the transition more smooth since it needs to calculate itself
	#every time.
	velocity = move_and_slide_with_snap(velocity,Vector2(0,20),Vector2.DOWN,false,
		MAX_FLOOR_ANGLE)
	
	pass
