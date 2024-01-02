class_name MenuRootController extends Control

# array of packed scenes of menu contexts
@export var context_scenes:Array

# list of currently opened menu contexts (0 = BOTTOM)
var context_list:Array 


func on_trigger(_sel_x:int, sel_y:int) -> void:
	
	match sel_y:
		0:
			%AnimationPlayer.play("Close")
			%MainMenu.config_focus()
			%MainMenu.anim.play("SlideUp")
			var temp = context_scenes[0].instantiate()
			add_child(temp)
			#temp.position = Vector2(40.0, 40.0)
			context_list.append(temp)
			temp.open_context()


func on_cancel() -> void:
	pass
