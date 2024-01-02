class_name FieldMenuController extends CanvasLayer


@onready var junction_context:PackedScene = preload("res://UI/Menu/JunctionMenuContext.tscn")
@onready var default_context:MenuContextController = %DefaultContext
@onready var main_menu:MenuBase = %MainMenu
@onready var context_container:Control = %ContextContainer
@onready var main_menu_anim:MarginContainer = main_menu.get_node("NinePatchRect/SelectionHeaderOffset")

var current_context:MenuContextController

func _ready() -> void:
	main_menu.open()


func _on_main_menu_menu_selection(sel:Vector2) -> void:
	main_menu.close(false) # do not hide on close
	main_menu_anim.add_theme_constant_override("margin_top", 200)
	
	default_context.anim.play("Close")
	await default_context.anim.animation_finished

	match sel:

		Vector2(0, 0):
			current_context = junction_context.instantiate()
			context_container.add_child(current_context)
			context_container.move_child(current_context, 0)
			current_context.tree_exiting.connect(_on_sub_context_closed)
			current_context.open_context()
			default_context.visible = false


func _on_sub_context_closed() -> void:
	default_context.anim.play("Open")
	main_menu.open()
	main_menu_anim.add_theme_constant_override("margin_top", 0)
