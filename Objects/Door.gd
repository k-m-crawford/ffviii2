class_name Door extends Discoverable

@onready var anim:AnimationPlayer = $AnimationPlayer

var is_open:bool = false

func on_trigger() -> void:
	
	if not is_open:
		anim.play("Open")
		await anim.animation_finished
		is_open = true
		if scene:
			Bucket.root_hook.change_scene(scene, spawn)
	if is_open:
		anim.play("Close")
		is_open = false
