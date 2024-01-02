extends CharacterBody3D


const SPEED:float = 3
const JUMP_VELOCITY:float = 3


@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var discoverable_raycast:RayCast3D = $DiscoverableRaycast
@onready var alert_bubble:PackedScene = preload("res://Misc/AlertBubble.tscn")


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var facing:String = "Down"
var alert_bubble_instance:Sprite3D
var has_discoverable:Discoverable

func _unhandled_input(event:InputEvent) -> void:
	if Bucket.in_vignette: return
	# Handle Jump.
	if event.is_action_pressed("ui_accept") and is_on_floor():
		if has_discoverable and has_discoverable.discoverable and not has_discoverable.auto_trigger:
			has_discoverable.on_trigger()
			(alert_bubble_instance.get_node("AnimationPlayer") as AnimationPlayer).play("PopClosed") # unloads self
			alert_bubble_instance = null
		else:
			velocity.y = JUMP_VELOCITY


func _physics_process(delta:float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Bucket.in_vignette: return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir:Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction:Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		discoverable_raycast.target_position = Vector3(velocity.x/4, 0, velocity.z/4)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if velocity.x < 0: facing = "Left"
	elif velocity.x > 0: facing = "Right"
	elif velocity.z < 0: facing = "Up"
	elif velocity.z > 0: facing = "Down"

	if velocity: anim.play("Walk/"+facing)
	else: anim.play("Idle/"+facing)

	check_for_discoverables()
	move_and_slide()


func check_for_discoverables() -> void:
	has_discoverable = discoverable_raycast.get_collider()
	
	if has_discoverable and has_discoverable.discoverable and has_discoverable.auto_trigger:
		has_discoverable.on_trigger()
	
	elif has_discoverable and has_discoverable.discoverable and not alert_bubble_instance:
		alert_bubble_instance = alert_bubble.instantiate()
		add_child(alert_bubble_instance)

	elif not has_discoverable and alert_bubble_instance:
		(alert_bubble_instance.get_node("AnimationPlayer") as AnimationPlayer).play("PopClosed") # unloads self
		alert_bubble_instance = null
	
