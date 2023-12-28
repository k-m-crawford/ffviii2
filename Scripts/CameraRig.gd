extends Node3D

@export var player:CharacterBody3D
@onready var camera_3d = $Camera3D
@onready var boundaries = [$BoundaryBack.position.z, $BoundaryLeft.position.x, 
							$BoundaryFront.position.z, $BoundaryRight.position.x]


func hook_focus(focus):
	player = focus


func _process(delta):
	if !player: return
	position = lerp(position,Vector3(player.position.x, player.position.y + 1.0, player.position.z),delta*10.0)
	position.x = clampf(position.x,boundaries[1],boundaries[3])
	position.z = clampf(position.z,boundaries[0], boundaries[2])
	
#	camera_3d.look_at(((player.position+position)/2)+Vector3.UP,Vector3.UP)
	
#	$MeshInstance3D2.global_position = ((player.position+position)/2)+Vector3.UP
	
