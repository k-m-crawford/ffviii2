extends MenuBase


@onready var menu_handle:Control = %JunctionGFMenuMover

var spells_on_page:Array = []


func _ready() -> void:
	@warning_ignore("integer_division")
	max_pages = Bucket.spell_inventory.size() / (column_entry[0].get_children().size() + 1)
	super()


func open(view:PlayerCharacter=null) -> void:
	
	super(view)
	populate_labels({})


func populate_labels(data:Dictionary) -> void:
	spells_on_page = []
	
	var true_x:int = 0
	var true_y:int = 0
	
	for int:x in range()
	
	# draw GF inventory menu
	for i:int in range(cur_page * option_labels.size(), cur_page * option_labels.size() + option_labels.size()):
		
		if i < Bucket.spell_inventory.size():
			data[Vector2(0, true_i)] = Bucket.spell_inventory[i][0]
			spells_on_page.append(Bucket.spell_inventory[i][0])
			
			#if(Bucket.gfs[i] as GF).junctioned:
				#option_labels.get(Vector2(0, true_i)).is_disabled = true
			#else:
				#option_labels.get(Vector2(0, true_i)).is_disabled = false
			
		else:
			data[Vector2(0, true_i)] = ""
		
		true_i += 1
	
	#prepopulate_page({}, -1)
	#prepopulate_page({}, 1)
	super(data)
