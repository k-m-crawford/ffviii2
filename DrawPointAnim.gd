extends PathFollow3D

var speed = randf_range(1.1, 1.5)
var delay = randf_range(0.0, 1.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_ratio += delta * speed
	
	if progress_ratio >= 1:
		delay -= delta
		if delay <= 0:
			speed = randf_range(1.1, 1.5)
			delay = randf_range(0.0, 1.0)
			progress_ratio = 0
		
		
