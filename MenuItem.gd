class_name MenuItem extends CanvasItem


signal on_select


@export var is_disabled:bool = false:
	set(val):
		if not val:
			self.modulate = Color(1,1,1,1)
		else:
			self.modulate = Color(0.5,0.5,0.5,1)
		
