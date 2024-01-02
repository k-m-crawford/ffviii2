class_name Discoverable extends PhysicsBody3D

# if discoverable, can be triggered
@export var discoverable:bool = true
@export var auto_trigger:bool = false

@export var scene:String
@export var spawn:String


@export var dialogue_resource:DialogueResource
@export var dialogue_title:String = "default"

func on_trigger() -> void:
	discoverable = false
	var balloon:DialogueDefaultBalloon = Bucket.default_balloon.instantiate() as DialogueDefaultBalloon
	add_child(balloon)
	balloon.start(dialogue_resource, dialogue_title)
	
	discoverable = true
