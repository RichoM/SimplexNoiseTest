extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_object_local(Vector3.UP, 0.1 * delta)
