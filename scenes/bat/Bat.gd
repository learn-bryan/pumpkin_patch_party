extends Spatial

export var MOVE_SPEED = 10.0
export(int, 0, 3, 1) var MODE = 0

onready var pivot = $Pivot

var move_direction = Vector3()
var t = 0.0 # time

func _ready():
	move_direction = Vector3(0.0, 0.0, 0.0)

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

func look(direction):
	# rotate around y axis
	if ( direction != Vector3.ZERO ):
		pivot.look_at(transform.origin + direction, Vector3.UP) # movement direction relative to camera

func apply_movement(direction, delta):
	var target = transform.origin + direction * MOVE_SPEED * delta
	set_global_position(self, target)

func set_global_position(spatialNode, vector3Position):
	spatialNode.set_global_transform(Transform(spatialNode.get_global_transform().basis,vector3Position))   
