extends Area3D


@export var target_scene:String
@export var target_spawn:String


#TODO: check is player
func _on_body_entered(_body):
	print(target_scene)
	get_tree().get_root().get_node("root").change_scene(target_scene, target_spawn)
