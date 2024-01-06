class_name DataStream

static func data_request(handle:String, attributes:Array[String], null_pad:String="") -> Array:
	
	if handle not in Bucket: return ["ERR: ", handle, " not found in Bucket."]
	
	if attributes[0] == "OBJECT": return Bucket.get(handle)
	
	var stream:Array = Bucket.get(handle)
	var construct:Array = []
	
	# ex. handle = "GFs", for obj in Bucket.gfs array
	for obj:Resource in stream:
		var entry:Array = []
		for attribute:String in attributes:
			if attribute in obj: 
				entry.append(obj.get(attribute))
			else:
				entry.append(null_pad)
		construct.append(entry)
		
	return construct
