class_name PortalPoint extends Area3D


@export var target_scene:String
@export var target_spawn:String


#TODO: check is player
func _on_body_entered(_body):
	Bucket.root_hook.change_scene(target_scene, target_spawn)
