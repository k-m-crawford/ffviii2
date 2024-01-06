# Data-driven menu with pagination options
# i.e., not a static menu
# preconditions: ALL columns must contain same amount of entries
class_name DataMenu extends MenuBase

@onready var menu_handle:Control = %PageControl

var on_page:Array = []
@export var data_feed:Array[Array]


func _ready() -> void:
	if not items_per_page: items_per_page = column_entry[0].get_children().size()
	@warning_ignore("integer_division")
	max_pages = data_feed.size() / items_per_page + 1
	super()
	print("MAX PAGES :", max_pages, " ", data_feed.size())
	print(current_view)


func open(view:PlayerCharacter=null) -> void:
	populate_page(-1)
	populate_page(0)
	populate_page(1)
	super(view)


func populate_page(dir:int) -> void:
	on_page = []
	
	var true_i:int = 0
	var hyp_page:int = cur_page
	var data:Dictionary = {} 
	
	if hyp_page + dir < 0: hyp_page = max_pages
	elif hyp_page + dir > max_pages: hyp_page = 0
	else: hyp_page = hyp_page + dir

	# iterate columns
	for j:int in range(0, column_entry.size()):
		for i:int in range(hyp_page * option_labels.size(), hyp_page * option_labels.size() + option_labels.size()):

			print(j, ", ", i, items_per_page)
			if i < data_feed[j].size():
				print("Populating label ", j, ", ", true_i, " with ", data_feed[j][i])
				data[Vector2(j, true_i)] = data_feed[j][i]
				on_page.append(data_feed[j][i]) 
				#TODO: check above 
					
					#check disabled condition
				
			else:
				data[Vector2(j, true_i)] = ""
		
			true_i += 1
		
	var target_labels:Dictionary = option_labels
	if dir != 0: target_labels = prev_labels if dir == -1 else next_labels
	
	for k:Vector2 in data:
		if target_labels.get(k):
			print(k)
			target_labels[k].text = data.get(k)


func populate_labels(_data:Dictionary) -> void:
	populate_page(-1)
	populate_page(0)
	populate_page(1)
	
#
#func set_page(val:int) -> void:
	#pointer.visible = false
	#if val > cur_page: anim.play("PageNext")
	#if val < cur_page: anim.play("PagePrev")
	#await anim.animation_finished
	#
	#if val < 0: cur_page = max_pages
	#elif val > max_pages: cur_page = 0
	#else: cur_page = val
	#
	#populate_labels({})
	#
	#menu_handle.position = Vector2(-404, 0)
	#
	#await get_tree().process_frame
	#
	#sel = Vector2.ZERO
	#set_pointer_pos()
	#pointer.visible = true


#func selection_function() -> void:
	#
	#var selected_gf:GF = gfs_on_page[sel.y]
	#
	#if selected_gf.junctioned and selected_gf in current_view.junctioned_gfs:
		#current_view.junction_gf(selected_gf)
	#elif not selected_gf.junctioned:
		#current_view.junction_gf(selected_gf)
	#
	#populate_labels({})
