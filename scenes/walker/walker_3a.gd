extends Spatial


onready var leg1_anim = $CharacterController/Body/Armature/AnimationPlayer2
onready var leg2_anim = $CharacterController/Body/Armature001/AnimationPlayer
onready var leg3_anim = $CharacterController/Body/Armature002/AnimationPlayer
onready var leg4_anim = $CharacterController/Body/Armature003/AnimationPlayer


func _ready():
	leg1_anim.stop(true)
	leg2_anim.stop(true)
	leg3_anim.stop(true)
	leg4_anim.stop(true)
	leg1_anim.play("ArmatureAction")
	leg2_anim.play("ArmatureAction")
	leg3_anim.play("ArmatureAction")
	leg4_anim.play("ArmatureAction")
