class_name DialogueDefaultBalloon
extends CanvasLayer

@onready var balloon: Control = %Balloon
@onready var dialogue_box: NinePatchRect = %DialogueBox
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu
@onready var small_test: RichTextLabel = %SmallTest
@onready var medium_test: RichTextLabel = %MediumTest
@onready var long_test: RichTextLabel = %LongTest
@onready var response_template: RichTextLabel = %ResponseTemplate
@onready var anim: AnimationPlayer = %AnimationPlayer


## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

var last_speaker: String = ""

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		if "vignette": Bucket.in_vignette = true

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			anim.play("Close")
			await anim.animation_finished
			queue_free()
			if "vignette": Bucket.in_vignette = false
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		var needs_animation: bool = dialogue_line == null or next_dialogue_line.time == null
		
		if needs_animation and visible:
			anim.play("Close")
			await anim.animation_finished
		
		dialogue_line = next_dialogue_line
		
		if last_speaker != dialogue_line.character:
			needs_animation = true
			anim.play("Close")
			await anim.animation_finished
		
		last_speaker = dialogue_line.character
		
		
		var balloon_size = Vector2(0, 12)
		var next_position = Vector2(12, 12)

		character_label.visible = not dialogue_line.character.is_empty()
		if character_label.visible:
			print("bro")
			character_label.text = tr(dialogue_line.character, "dialogue")
			character_label.position = next_position
			next_position.y += character_label.size.y + 10.0
			balloon_size.y += character_label.size.y + 5.0
		else:
			next_position.y += 5.0

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line
		dialogue_label.position = next_position
		
		small_test.size = Vector2.ZERO
		medium_test.size = Vector2.ZERO
		long_test.size = Vector2.ZERO
		
		small_test.text = dialogue_line.text
		medium_test.text = dialogue_line.text
		long_test.text = dialogue_line.text
		
		await get_tree().process_frame
		
		var shortest_height: float = INF
		var best_size: Vector2 = Vector2.ZERO
		
		for label in [long_test, medium_test, small_test]:
			if label.get_content_height() <= shortest_height:
				shortest_height = label.get_content_height()
				best_size = Vector2(label.size.x, shortest_height)
				
		dialogue_label.size = best_size
		next_position.y += dialogue_label.size.y + 15
		balloon_size += best_size + Vector2(30.0, 25.0)
		
		responses_menu.hide()
		var longest_response_width:float = responses_menu.set_responses(dialogue_line.responses, best_size)
		
		if longest_response_width > 0: 
			responses_menu.size = Vector2(longest_response_width, responses_menu.size.y)
			responses_menu.position = next_position + Vector2(50, 0)
			balloon_size = Vector2(
				max(balloon_size.x, responses_menu.size.x + 50),
				balloon_size.y + responses_menu.size.y + 10
			)
			#responses_menu.show()
		
		dialogue_box.size = balloon_size

		# Show our balloon
		balloon.show()
		will_hide_balloon = false
		
		balloon.position = Vector2(250,250)
		
		if needs_animation:
			anim.play("Open")
			await anim.animation_finished

		dialogue_label.show()
		
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


func _unhandled_input(event: InputEvent) -> void:
	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	if event.is_action_pressed("ui_accept"):
		next(dialogue_line.next_id)
	
	get_viewport().set_input_as_handled()
	


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)
