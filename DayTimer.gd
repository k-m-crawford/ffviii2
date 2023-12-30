extends DirectionalLight3D
#
#@export var time_of_day := 0.0 # scale from 0 to 24 hr; 2-10 am morning (yellow light), 10 - 8 pm (day), 8 - 2 night 
#@export var sunrise := 8.0
#@export var sunset := 18.0
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#
	#time_of_day += delta
	#if time_of_day > 24: time_of_day = time_of_day - 24.0
	#
	#print(time_of_day)
	#print(light_energy)
	#print("ROT", rotation_degrees.y)
	#
	#if time_of_day > sunrise and time_of_day < sunset:
		#if light_energy < 2:
			#light_energy += delta
		#
		#rotation_degrees.y += delta * 25
