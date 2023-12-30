class_name Discoverable extends PhysicsBody3D

# if discoverable, can be triggered
@export var discoverable = true
@export var auto_trigger = false

@export var scene:String
@export var spawn:String


@export var dialogue_resource:DialogueResource
@export var dialogue_title:String = "default"

func on_trigger():
	discoverable = false
	var balloon: Node = Bucket.default_balloon.instantiate()
	add_child(balloon)
	balloon.start(dialogue_resource, dialogue_title)
	
	discoverable = true
