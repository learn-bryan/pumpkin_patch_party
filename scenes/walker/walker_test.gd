extends Spatial


onready var leg1_anim = $CharacterController/Body/Armature/AnimationPlayer
onready var leg2_anim = $CharacterController/Body/Armature001/AnimationPlayer
onready var leg3_anim = $CharacterController/Body/Armature002/AnimationPlayer
onready var leg4_anim = $CharacterController/Body/Armature003/AnimationPlayer

export var MOVE_SPEED = 4.0
export(int, 0, 3, 1) var MODE = 0
export var MIN_SCALE = 0.2
export var MAX_SCALE = 0.4

onready var pivot = $CharacterController

var move_direction = Vector3()
var t = 0.0 # time

func _ready():
	# randomize movement config
	randomize()
	var rng = RandomNumberGenerator.new()
	self.scale = Vector3(rand_range(MIN_SCALE, MAX_SCALE),rand_range(MIN_SCALE, MAX_SCALE),rand_range(MIN_SCALE, MAX_SCALE))
	MODE = randi() % 4 # int between 0 and 3
	MOVE_SPEED = rand_range(MOVE_SPEED*0.5, MOVE_SPEED*2.0)
	var look_bias = Vector3(rng.randfn(),0.0,rng.randfn()).normalized()
	look(look_bias)
	
	move_direction = Vector3(0.0, 0.0, 0.0)
	walk_anim(true)

func _physics_process(delta):
	t += delta / 2.0
	if t >= 1000: # overflow
		t = 0.0
	if (MODE == 0):
		move_direction = Vector3(sin(t), 0.0, cos(t)/2)
	elif (MODE == 1):
		move_direction = Vector3(-sin(t), 0.0, cos(t)/2)
	elif (MODE == 2):
		move_direction = Vector3(sin(t), 0.0, -cos(t)/2)
	elif (MODE == 3):
		move_direction = Vector3(sin(t)/2, 0.0, cos(t)/2)
	#move_direction = Vector3(sin(t), 0.0, cos(t)) # circle
	#move_direction = Vector3(sin(t), 0.0, sin(t)) # back n forth
	
	apply_movement(move_direction, delta)
	look(-1*move_direction)

func walk_anim(play):
	if play:
		leg4_anim.stop(true)
		leg1_anim.play("ArmatureAction")
		leg2_anim.play("ArmatureAction")
		leg3_anim.play("ArmatureAction")
		leg4_anim.play("ArmatureAction")
	else:
		leg1_anim.stop(true)
		leg2_anim.stop(true)
		leg3_anim.stop(true)
		leg4_anim.stop(true)

func look(direction):
	# rotate around y axis
	if ( direction != Vector3.ZERO ):
		pivot.look_at(transform.origin + direction, Vector3.UP) # movement direction relative to camera

func apply_movement(direction, delta):
	var target = transform.origin + move_direction * MOVE_SPEED * delta
	set_global_position(self, target)

func set_global_position(spatialNode, vector3Position):
	spatialNode.set_global_transform(Transform(spatialNode.get_global_transform().basis,vector3Position))   
