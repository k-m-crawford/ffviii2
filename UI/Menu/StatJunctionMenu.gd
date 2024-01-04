extends MenuBase

func populate_labels(_data:Dictionary) -> void:
	
	if(current_view): print(" VIEW ", current_view.junctionable_stats)
	
	if not current_view: return
	
	for k:Vector2 in option_labels:
		
		var junctionable:bool = false
		var magic_label:Label
		var stat_val_label:Label
		
		if k != Vector2(1, 0):
			magic_label = (option_labels.get(k) as Node).get_child(1)
			stat_val_label = (option_labels.get(k) as Node).get_child(2)
		
		match k:
			Vector2(0, 0): 
				if Bucket.Stat.HP in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.HP])
			Vector2(0, 1): 
				if Bucket.Stat.STR in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.STR])
			Vector2(0, 2): 
				if Bucket.Stat.VIT in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.VIT])
			Vector2(0, 3): 
				if Bucket.Stat.MAG in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.MAG])
			Vector2(0, 4): 
				if Bucket.Stat.SPR in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.SPR])
			Vector2(1, 1): 
				if Bucket.Stat.SPD in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.SPD])
			Vector2(1, 2): 
				if Bucket.Stat.EVA in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.EVA])
			Vector2(1, 3): 
				if Bucket.Stat.HIT in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.HIT])
			Vector2(1, 4): 
				if Bucket.Stat.LUCK in current_view.junctionable_stats: junctionable = true
				if stat_val_label: stat_val_label.text = str(current_view.stat_dict[Bucket.Stat.LUCK])
		
		if junctionable: option_labels[k].modulate = Color(1,1,1,1)
		else: option_labels[k].modulate = Color(0.5,0.5,0.5,1)
