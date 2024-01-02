class_name MenuBase extends Control


signal selection_change(tooltip:String)
signal menu_selection(sel:Vector2)
signal menu_cancel


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

@export_category("Setup")
@export var column_entry:Array[NodePath]
@export var horizontal_orientation:bool = false
@export var selection_position_override:Dictionary
@export var parent_menu:MenuBase

@export_category("Pagination")
@export var navigation:CanvasItem
@export var items_per_page:int

@export_category("Boundary Behaviors")
@export var up_boundary:MenuBoundaryBehavior = MenuBoundaryBehavior.NOTHING
@export var down_boundary:MenuBoundaryBehavior = MenuBoundaryBehavior.NOTHING
@export var left_boundary:MenuBoundaryBehavior = MenuBoundaryBehavior.NOTHING
@export var right_boundary:MenuBoundaryBehavior = MenuBoundaryBehavior.NOTHING

@export_category("Settings")
# Array of arrays of possible selections in XY format [COL][ROW]
@export var cursor_memory:bool = false
@export var close_on_cancel:bool = true
@export var in_focus:bool = false

@export_category("Debug")
@export var debug:bool = false
@export var current_view:PlayerCharacter

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var pointer:TextureRect = $Pointer

var option_labels:Dictionary
var sel:Vector2 = Vector2.ZERO
var cur_page:int = 0:
	set(val):
		if val < 0: cur_page = max_pages
		elif val > max_pages: cur_page = 0
		else: cur_page = val
		populate_labels({})
		sel = Vector2.ZERO
		set_pointer_pos()
var max_pages:int = 0

func _ready() -> void:
	
	# set up based on COLUMN ENTRY nodes
	var x:int = 0
	for path:NodePath in column_entry:
		var n:Node = get_node(path)
		var y:int = 0
		
		for child:Node in n.get_children():
			var coord:Vector2 = Vector2(x, y)
			if horizontal_orientation: coord = Vector2(y, x)
			option_labels[coord] = child
			y += 1
		x += 1
	
	# set up based on SELECTION POSITION OVERRIDES
	for k:Vector2 in selection_position_override.keys():
		option_labels[k] = get_node(selection_position_override.get(k) as NodePath)
	
	if not cursor_memory: cur_page = 0
	
	if max_pages > 0 and navigation:
		navigation.visible = true
	
	if debug:
		if current_view: open(current_view)
		else: open()

func _input(event:InputEvent) -> void:
	if not in_focus: return
	
	if event.is_action_pressed("ui_up"):
		if sel.y > 0:
			sel = sel - Vector2(0.0, 1.0)
			emit_signal("selection_change", option_labels[sel].tooltip_text)
		else:
			pass # BOUNDARY FUNC
		
	elif event.is_action_pressed("ui_down"):
		if sel + Vector2(0.0, 1.0) in option_labels and option_labels[sel + Vector2(0, 1)].text != "":
			sel = sel + Vector2(0.0, 1.0)
			emit_signal("selection_change", option_labels[sel].tooltip_text)
		else:
			pass # BOUNDARY FUNC
	
	elif event.is_action_pressed("ui_left"):
		if sel.x > 0:
			sel = sel - Vector2(1.0, 0.0)
			emit_signal("selection_change", option_labels[sel].tooltip_text)
		else:
			boundary_func(MenuBoundaryDir.LEFT)
	
	elif event.is_action_pressed("ui_right"):
		if sel + Vector2(1.0, 0.0) in option_labels and option_labels[sel + Vector2(1, 0)].text != "":
			sel = sel + Vector2(1.0, 0.0)
			emit_signal("selection_change", option_labels[sel].tooltip_text)
		else:
			boundary_func(MenuBoundaryDir.RIGHT)
	
	elif event.is_action_pressed("ui_accept"):
		# emit signals for outside contexts
		emit_signal("menu_selection", sel)
		# emit individual item signal
		if option_labels.get(sel) as MenuItem:
			(option_labels.get(sel) as MenuItem).emit_signal("on_select")
	
	elif event.is_action_pressed("ui_cancel"):
		emit_signal("menu_cancel")
		if close_on_cancel: close()
	
	get_viewport().set_input_as_handled()
	
	set_pointer_pos()


func open(view:PlayerCharacter=null) -> void:
	
	print("opening ", self, " with view ", view)
	
	if view: current_view = view
	elif parent_menu: 
		print("no view set, checking parent view")
		print(parent_menu.current_view)
		current_view = parent_menu.current_view
	
	print("VIEW set: ", current_view)
	
	if parent_menu: parent_menu.config_focus() # turn focus off parent
	if anim.has_animation("Open"): 
		anim.play("Open")
		await anim.animation_finished
	else: visible = true
	
	await get_tree().process_frame
	
	config_focus()


func close(hide_on_close:bool = false) -> void:
	config_focus()
	if anim.has_animation("Close"): 
		anim.play("Close")
		await anim.animation_finished
	
	visible = not hide_on_close
	
	if parent_menu: parent_menu.config_focus()


func set_pointer_pos() -> void:
	if not option_labels: return
	pointer.global_position = option_labels[sel].global_position
	pointer.global_position.x -= pointer.size.x + 4.0


func config_focus() -> void:
	print("CONFIGING FOCUS ON ", self)
	
	if not cursor_memory:
		sel = Vector2.ZERO
	
	set_pointer_pos()
	pointer.visible = not pointer.visible
	in_focus = not in_focus


func boundary_func(dir:int) -> void:
	
	var behavior:int
	
	match dir:
		MenuBoundaryDir.UP:
			behavior = up_boundary
		MenuBoundaryDir.DOWN:
			behavior = down_boundary
		MenuBoundaryDir.LEFT:
			behavior = left_boundary
		MenuBoundaryDir.RIGHT:
			behavior = right_boundary

	match behavior:
		MenuBoundaryBehavior.LOSE_FOCUS:
			config_focus()
			match dir:
				MenuBoundaryDir.LEFT:
					if focus_neighbor_left:
						(get_node(focus_neighbor_left) as MenuBase).config_focus()
				MenuBoundaryDir.RIGHT:
					if focus_neighbor_right:
						(get_node(focus_neighbor_right) as MenuBase).config_focus()
		
		MenuBoundaryBehavior.PAGINATE_DECR:
			cur_page -= 1
		
		MenuBoundaryBehavior.PAGINATE_INCR:
			cur_page += 1


func populate_labels(data:Dictionary) -> void:
	for k:Vector2 in data:
		if option_labels.get(k):
			option_labels[k].text = data.get(k)
