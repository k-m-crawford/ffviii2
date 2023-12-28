class_name OverworldScene
extends Node3D


@export var spawn_points := {}


@onready var player_packed = preload("res://Player.tscn")
@onready var camera_rig_packed = preload("res://Misc/CameraRig.tscn")


var player
var camera_rig


func set_spawn(target_spawn):
	player = player_packed.instantiate()
	player.position = get_node(spawn_points[target_spawn]).position
	add_child(player)
	move_child(player, 0)
	
	camera_rig = camera_rig_packed.instantiate()
	camera_rig.hook_focus(player)
	add_child(camera_rig)
	
