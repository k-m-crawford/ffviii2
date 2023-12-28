extends StaticBody3D

@export var discoverable = true

func on_trigger():
	discoverable = false
	
	var resource = load("res://test.dialogue")
	var balloon: Node = Bucket.default_balloon.instantiate()
	add_child(balloon)
	balloon.start(resource, "this_is_a_node_title")
	
	discoverable = true
