extends MenuBase


@onready var junctioned_gfs:Array = [
	%GF1,
	%GF2,
	%GF3,
	%GF4
]


var gfs_on_page:Array = []


func _ready() -> void:
	super()
	@warning_ignore("integer_division")
	max_pages = Bucket.gfs.size() / option_labels.size()
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
	
	# draw equipped gf menu
	for i:int in range(0, junctioned_gfs.size()):
		junctioned_gfs[i].text = ""
		
		if current_view and i < current_view.junctioned_gfs.size():
			junctioned_gfs[i].text = (current_view.junctioned_gfs[i] as GF).name
	
	
	super(data)


func selection_function() -> void:
	
	var selected_gf:GF = gfs_on_page[sel.y]
	
	if selected_gf.junctioned and selected_gf in current_view.junctioned_gfs:
		current_view.junction_gf(selected_gf)
	elif not selected_gf.junctioned:
		current_view.junction_gf(selected_gf)
	
	populate_labels({})
