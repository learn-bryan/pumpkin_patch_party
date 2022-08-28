extends Spatial

export(float, 0.1, 5.0, 0.1) var rotation_speed = PI/3
export var zoom_speed = 0.07

export var z_offset = 19

export(float, 0.01, 3.0, 0.01) var zoom

func _ready():
	#$InnerGimbal/Camera.translate(Vector3(0.0, 0.0, z_offset))
	$InnerGimbal/Camera.translate_object_local(Vector3(0.0, 0.0, z_offset))

func _process(delta):
	var y_rot = 0
	var x_rot = 0
	
	# Y-axis movement inputs
	if Input.is_action_pressed("camera_right"):
		y_rot -= 1
	if Input.is_action_pressed("camera_left"):
		y_rot += 1
	
	# X-axis movement inputs
	if Input.is_action_pressed("camera_up"):
		x_rot += 1
	if Input.is_action_pressed("camera_down"):
		x_rot -= 1
	
	# zoom inputs
	if Input.is_action_pressed("camera_in"):
		zoom -= zoom_speed / (1/zoom)
	if Input.is_action_pressed("camera_out"):
		zoom += zoom_speed / (1/zoom)
	zoom = clamp(zoom, 0.0001, 3.0)
	
	# rotate outer gimbal around y axis
	rotate_object_local(Vector3.UP, y_rot * rotation_speed * delta)
	
	# rotate inner gimbal around x axis
	$InnerGimbal.rotate_object_local(Vector3.RIGHT, x_rot * rotation_speed * delta)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, -0.01)
	
	# apply zoom
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
