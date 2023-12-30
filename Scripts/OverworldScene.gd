class_name OverworldScene
extends Node3D

@export var map_name:String = ""
@export var spawn_points := {}


@onready var player_packed = preload("res://Player.tscn")
@onready var camera_rig = %CameraRig

var player

func set_spawn(target_spawn):
	player = player_packed.instantiate()
	player.position = get_node(spawn_points[target_spawn]).position
	add_child(player)
	camera_rig.hook_focus(player)
	move_child(player, 0)


func get_map_name(): return map_name
