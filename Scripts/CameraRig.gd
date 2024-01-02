class_name CameraRig extends Node3D

@export var boundary_left:float = -10.0
@export var boundary_right:float = 10.0
@export var boundary_back:float = -10.0
@export var boundary_front:float = 10.0

@onready var camera_3d:Camera3D = $Camera3D

var player:CharacterBody3D


func hook_focus(focus:CharacterBody3D) -> void:
	player = focus 
	position = Vector3(player.position.x, player.position.y + 0.5, player.position.z - 2)


func _process(delta:float) -> void:
	if !player: return
	position = lerp(position,Vector3(player.position.x, player.position.y + 0.5, player.position.z - 2),delta*10.0)
	position.x = clampf(position.x, boundary_left, boundary_right)
	position.z = clampf(position.z, boundary_back, boundary_front)
	
#	camera_3d.look_at(((player.position+position)/2)+Vector3.UP,Vector3.UP)
	
#	$MeshInstance3D2.global_position = ((player.position+position)/2)+Vector3.UP
