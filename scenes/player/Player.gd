extends Spatial

onready var pivot = $Pivot
onready var cam = $CameraGimbal/InnerGimbal/Camera

onready var animate = $"Pivot/Pump Kin/AnimationPlayer"

export var MOVE_SPEED = 0.5

var look_direction = Vector3()
var move_direction = Vector3()
var move_weight = 1.0

var hidden = false
var anim_lock = false

func _ready():
	animate.connect("animation_finished", self, "anim_fin")

func _physics_process(delta):
	get_input() 
	
	# direct
	look(look_direction)
	apply_movement(move_direction, delta)

func apply_movement(direction, delta):
	var target = transform.origin + direction * MOVE_SPEED * move_weight * delta
	# bind position within fense area
	target.x = clamp(target.x, -71.859, 72.859) # x-axis
	target.z = clamp(target.z, -326.473, 37.66) # z-axis
	set_global_position(self, target)

func set_global_position(spatialNode, vector3Position):
	spatialNode.set_global_transform(Transform(spatialNode.get_global_transform().basis,vector3Position))    

func look(direction):
	# rotate around y axis
	if ( direction != Vector3.ZERO ):
		pivot.look_at(transform.origin + direction, Vector3.UP) # movement direction relative to camera
	
	
func get_input():
	look_direction = Vector3(0.0, 0.0, 0.0) # direction relative to camera
	var cam_xform = cam.get_global_transform()
	var s = 0.0
	var strength = Vector2(0.0, 0.0)
	move_weight = 1.0
	
	# right
	s = Input.get_action_strength("player_right")
	strength.x += s
	look_direction += -cam_xform.basis[0] * s
	# left
	s = Input.get_action_strength("player_left")
	strength.x += s
	look_direction += cam_xform.basis[0] * s
	# forward
	s = Input.get_action_strength("player_up")
	strength.y += s
	look_direction += cam_xform.basis[2] * s
	# backward
	s = Input.get_action_strength("player_down")
	strength.y += s
	look_direction += -cam_xform.basis[2] * s
	
	# actions
	if Input.is_action_pressed("player_action"):
		if not anim_lock:
			anim_lock = true
			if hidden:
				animate.play("unhide_anim")
			else:
				animate.play("hide_anim")
		
		
	
	look_direction.y = 0
	look_direction = look_direction.normalized()
	move_direction = -1 * look_direction
	move_weight = max(abs(strength.x), abs(strength.y))

func anim_fin(_anim_name):
	hidden = !hidden
	anim_lock = false
	
