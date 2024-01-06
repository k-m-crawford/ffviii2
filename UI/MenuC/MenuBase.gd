class_name MenuBase2 extends Control


signal selection_change
signal selection_accept
signal selection_cancel


enum MenuBoundaryBehavior {
	LOOP,
	NOTHING,
	LOSE_FOCUS,
	PAGINATE_DECR,
	PAGINATE_INCR
}

enum MenuBoundaryDir {
	UP,
	DOWN,
	LEFT,
	RIGHT
}


@export_group("Setup")
@export var column_entry:Array[Control]
@export var parent_menu:MenuBase
@export var pointer:TextureRect 
@export var anim:AnimationPlayer

@export_group("Pagination")
@export var navigation:CanvasItem
@export var labels_per_page:int
# NOTE: These should be THE SAME SIZE as COLUMN ENTRY and each control should have the same 
# number of children as each COLUMN ENTRY
@export var prev_column_entry:Array[Control]
@export var next_column_entry:Array[Control]
@export var max_pages:int = 0

@export_group("Settings")
@export var cursor_memory:bool = false
@export var in_focus:bool = false
@export var selection_pruning:Dictionary
@export var horizontal_orientation:bool

@export_group("Data Stream")
@export var data_stream_request:String
@export var data_stream_attributes:Array[String]
@export var data_stream_null_pad:String
@export var data_stream_override:Array

@export_group("Debug")
@export var debug:bool = false
@export var debug_open:bool = false

var option_labels:Dictionary
var prev_labels:Dictionary
var next_labels:Dictionary
var sel:Vector2 = Vector2(1,0)
var cur_page:int = 0


func _ready() -> void:
	# set up based on COLUMN ENTRY nodes
	var x:int = 0
	for n:Control in column_entry:
		var y:int = 0
		
		for child:Node in n.get_children():
			var coord:Vector2 = Vector2(x, y) if not horizontal_orientation else \
								Vector2(y, x)
			
			#if horizontal_orientation: coord = Vector2(y, x)
			option_labels[coord] = child
			if prev_column_entry:
				prev_labels[coord] = prev_column_entry[coord.x as int].get_child(coord.y as int)
			if next_column_entry:
				next_labels[coord] = next_column_entry[coord.x as int].get_child(coord.y as int)
			
			y += 1
		
		x += 1
	
	if not pointer: pointer = get_node_or_null("Pointer")
	if not anim: anim = get_node_or_null("AnimationPlayer")
	
	if debug_open:
		open()
	
	# set up based on SELECTION POSITION OVERRIDES
	#for k:Vector2 in selection_position_override.keys():
		#option_labels[k] = get_node(selection_position_override.get(k) as NodePath)
		# TO DO EXTEND menus to allow overrides for PAGINATION
	
	#if not cursor_memory: cur_page = 0
	#
	#if max_pages > 0 and navigation:
		#navigation.visible = true
	
	#if debug:
		#if current_view: open(current_view)
		#else: open()


func open() -> void:
	if debug: print("OPENING ", self)
	if parent_menu: parent_menu.config_focus() # turn focus off parent
	
	if data_stream_request: populate_labels()
	
	if anim and anim.has_animation("Open"): 
		anim.play("Open")
		await anim.animation_finished
	else: visible = true
	
	config_focus()
	await get_tree().process_frame
	set_pointer_pos()
	# force position updating
	if pointer: pointer.visible = true


func close() -> void:
	if debug: print("CLOSING ", self)
	
	config_focus()
	pointer.visible = false
	if anim and anim.has_animation("Close"): 
		anim.play("Close")
		await anim.animation_finished
	
	if parent_menu: parent_menu.config_focus()


func config_focus() -> void:
	if debug: print("CONFIGURING FOCUS ON ", self)
	
	if not cursor_memory:
		sel = Vector2.ZERO
		
	in_focus = not in_focus


func _input(event:InputEvent) -> void:
	if not in_focus: return
	
	if event.is_action_pressed("ui_up"):
		if sel.y > 0:
			sel = sel - Vector2(0.0, 1.0)
			if sel in selection_pruning:
				sel = selection_pruning.get(sel)
			emit_signal("selection_change", option_labels[sel].tooltip_text)
		else:
			boundary_func(MenuBoundaryDir.UP)
		
	elif event.is_action_pressed("ui_down"):
		if sel + Vector2(0.0, 1.0) in option_labels: # and blank_option_check(Vector2(0, 1)):
			sel = sel + Vector2(0.0, 1.0)
			if sel in selection_pruning:
				sel = selection_pruning.get(sel)
			emit_signal("selection_change", option_labels[sel].tooltip_text)
		else:
			boundary_func(MenuBoundaryDir.DOWN)
	
	elif event.is_action_pressed("ui_left"):
		if sel.x > 0:
			sel = sel - Vector2(1.0, 0.0)
			if sel in selection_pruning:
				sel = selection_pruning.get(sel)
			emit_signal("selection_change", option_labels[sel].tooltip_text)
		else:
			boundary_func(MenuBoundaryDir.LEFT)
			
	elif event.is_action_pressed("ui_right"):
		if sel + Vector2(1.0, 0.0) in option_labels: # and blank_option_check(Vector2(1, 0)):
			sel = sel + Vector2(1.0, 0.0)
			if sel in selection_pruning:
				sel = selection_pruning.get(sel)
			emit_signal("selection_change", option_labels[sel].tooltip_text)
		else:
			boundary_func(MenuBoundaryDir.RIGHT)
	
	elif event.is_action_pressed("ui_accept"):
		# emit signals for outside contexts
		emit_signal("selection_accept", sel)
		# emit individual item signal
		if option_labels.get(sel) and "on_select" in option_labels.get(sel):
			(option_labels.get(sel) as MenuItem).emit_signal("on_select")
	
	elif event.is_action_pressed("ui_cancel"):
		emit_signal("selection_cancel")
		#if close_on_cancel: close()
	
	get_viewport().set_input_as_handled()
	set_pointer_pos()


func set_pointer_pos() -> void:
	if not option_labels: return
	
	
	pointer.set_global_position(Vector2(
		option_labels[sel].global_position.x - (pointer.size.x + 4.0),
		option_labels[sel].global_position.y
	))
	
	#if debug: print("SETTING CURSOR POS TO ", pointer.global_position)
	#print("op lab", option_labels[sel].global_position, ", sel ", sel)
	
	await get_tree().process_frame
	#print(pointer.position)


func boundary_func(_dir:int) -> void:
	pass


func populate_labels() -> void:
	
	var result:Array = DataStream.data_request(data_stream_request,
										data_stream_attributes, data_stream_null_pad)
	
	if debug: print("Data stream res: ", result)
	
	var i:int = 0
	for k:Vector2 in option_labels:
		print(result[i], i)
		
		if (option_labels.get(k) as Control).get_child_count() == 0:
			option_labels[k].text = result[i][0]
		
		else:
			var c:int = 0
			for child:Label in (option_labels.get(k) as Control).get_children():
				if result[i].size() > c: child.text = result[i][c]
				else: child.text = data_stream_null_pad
				c += 1
		
		i += 1
