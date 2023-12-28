extends Node


@export var current_scene:String
@export var starting_spawn:String


@onready var scene_fader = %SceneFadeAnim
@onready var UI = %UI:
	get:
		return UI


var scene_handle


func _ready():
	Bucket.root_hook = self
	change_scene(current_scene, starting_spawn)


func change_scene(target_scene, target_spawn):
	get_tree().paused = true
	scene_fader.play("FadeOut")
	if scene_handle: scene_handle.call_deferred("queue_free")
	scene_handle = load(target_scene).instantiate()
	add_child(scene_handle)
	scene_handle.set_spawn(target_spawn)
	scene_fader.play("FadeIn")
	get_tree().paused = false

