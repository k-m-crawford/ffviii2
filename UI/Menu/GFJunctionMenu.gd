extends MenuBase


@onready var junctioned_gf_slots:Array = [
	%GF1,
	%GF2,
	%GF3,
	%GF4
]
@onready var menu_handle:Control = %JunctionGFMenuMover

var gfs_on_page:Array = []


func _ready() -> void:
	@warning_ignore("integer_division")
	max_pages = Bucket.gfs.size() / (column_entry[0].get_children().size() + 1)
	super()
	print("MAX PAGES :", max_pages, " ", Bucket.gfs.size())
	print(current_view)


func open(view:PlayerCharacter=null) -> void:
	
	super(view)
	populate_labels({})


func populate_labels(data:Dictionary) -> void:
	gfs_on_page = []
	
	var true_i:int = 0
	
	# draw GF inventory menu
	for i:int in range(cur_page * option_labels.size(), cur_page * option_labels.size() + option_labels.size()):
		
		if i < Bucket.gfs.size():
			data[Vector2(0, true_i)] = (Bucket.gfs[i] as GF).name
			gfs_on_page.append(Bucket.gfs[i])
			
			if(Bucket.gfs[i] as GF).junctioned:
				option_labels.get(Vector2(0, true_i)).is_disabled = true
			else:
				option_labels.get(Vector2(0, true_i)).is_disabled = false
			
		else:
			data[Vector2(0, true_i)] = ""
		
		true_i += 1
	
	prepopulate_page({}, -1)
	prepopulate_page({}, 1)
	
	# draw equipped gf menu
	for i:int in range(0, junctioned_gf_slots.size()):
		junctioned_gf_slots[i].text = ""
		
		if current_view and i < current_view.junctioned_gfs.size():
			junctioned_gf_slots[i].text = (current_view.junctioned_gfs[i] as GF).name
	
	super(data)


func prepopulate_page(data:Dictionary, dir:int) -> void:
	
	var true_i:int = 0
	
	var hyp_page:int = cur_page
	
	if hyp_page + dir < 0: hyp_page = max_pages
	elif hyp_page + dir > max_pages: hyp_page = 0
	else: hyp_page = hyp_page + dir
	
	print("PREPOP", cur_page, dir, cur_page + dir, max_pages, hyp_page)
	
	# draw GF inventory menu
	for i:int in range(hyp_page * option_labels.size(), hyp_page * option_labels.size() + option_labels.size()):
		
		if i < Bucket.gfs.size():
			data[Vector2(0, true_i)] = (Bucket.gfs[i] as GF).name
			gfs_on_page.append(Bucket.gfs[i])
			
			if(Bucket.gfs[i] as GF).junctioned:
				if dir == -1: prev_labels.get(Vector2(0, true_i)).is_disabled = true
				if dir == 1: next_labels.get(Vector2(0, true_i)).is_disabled = true
			else:
				if dir == -1: prev_labels.get(Vector2(0, true_i)).is_disabled = false
				if dir == 1: next_labels.get(Vector2(0, true_i)).is_disabled = false
			
		else:
			data[Vector2(0, true_i)] = ""
		
		true_i += 1
	
	super(data, dir)


func set_page(val:int) -> void:
	pointer.visible = false
	if val > cur_page: anim.play("PageNext")
	if val < cur_page: anim.play("PagePrev")
	await anim.animation_finished
	
	if val < 0: cur_page = max_pages
	elif val > max_pages: cur_page = 0
	else: cur_page = val
	
	populate_labels({})
	
	menu_handle.position = Vector2(-404, 0)
	
	await get_tree().process_frame
	
	sel = Vector2.ZERO
	set_pointer_pos()
	pointer.visible = true


func selection_function() -> void:
	
	var selected_gf:GF = gfs_on_page[sel.y]
	
	if selected_gf.junctioned and selected_gf in current_view.junctioned_gfs:
		current_view.junction_gf(selected_gf)
	elif not selected_gf.junctioned:
		current_view.junction_gf(selected_gf)
	
	populate_labels({})
