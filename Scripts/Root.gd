class_name RootController extends Node


@export var current_scene:String
@export var starting_spawn:String


@onready var location_label:RichTextLabel = %LocationLabel
@onready var scene_fader:AnimationPlayer = %SceneEntryAnimator
@onready var UI:Control = %UI:
	get:
		return UI


var scene_handle:OverworldScene


func _ready() -> void:
	Bucket.root_hook = self
	change_scene(current_scene, starting_spawn)


func change_scene(target_scene:String, target_spawn:String) -> void:
	get_tree().paused = true
	scene_fader.play("FadeOut")
	await scene_fader.animation_finished
	if scene_handle: scene_handle.call_deferred("queue_free")
	scene_handle = (load(target_scene) as PackedScene).instantiate()
	add_child(scene_handle)
	scene_handle.set_spawn(target_spawn)
	location_label.text = scene_handle.get_map_name()
	scene_fader.play("FadeIn")
	get_tree().paused = false

