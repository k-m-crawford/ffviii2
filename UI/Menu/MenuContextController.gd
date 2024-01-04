class_name MenuContextController extends Control

signal propogate_view(view:PlayerCharacter)

@export var is_open:bool = false
@export var default_focus:MenuBase

@onready var anim:AnimationPlayer = %AnimationPlayer as AnimationPlayer
@onready var current_view:PlayerCharacter
@onready var next_view:PlayerCharacter

func _ready() -> void:
	current_view = Bucket.party[0]
	emit_signal("propogate_view", current_view)
	
	Bucket.subscribe_party_update(self)
	
	if is_open:
		open_context()
	else:
		visible = false

func open_context() -> void:
	if anim and anim.has_animation("Open"):
		anim.play("Open")
		await anim.animation_finished
	if default_focus: default_focus.open(current_view)


func close_context() -> void:
	if anim.has_animation("Close"):
		anim.play("Close")
		await anim.animation_finished
	queue_free()

