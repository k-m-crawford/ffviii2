class_name OverworldScene
extends Node3D

@export var map_name:String = ""
@export var spawn_points:Dictionary = {}


@onready var player_packed:PackedScene = preload("res://Player.tscn")
@onready var camera_rig:CameraRig = %CameraRig

var player:CharacterBody3D

func set_spawn(target_spawn:String) -> void:
	player = player_packed.instantiate()
	player.position = (get_node(spawn_points.get(target_spawn) as NodePath) as Node3D).position
	add_child(player)
	camera_rig.hook_focus(player)
	move_child(player, 0)


func get_map_name() -> String: return map_name
