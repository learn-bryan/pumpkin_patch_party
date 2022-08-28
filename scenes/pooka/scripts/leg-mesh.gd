extends MeshInstance

func _ready():
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	
#	for i in range(mdt.get_vertex_count()):
#		var vert = mdt.get_vertex(i)
#		vert *= 2.0 # Scales the vertex by doubling size.
#		mdt.set_vertex(i, vert)
	
#	for i in range(mdt.get_vertex_count()):
#		var vert = mdt.get_vertex(i)
#		vert += Vector3(0,0,0.471) # Shift vertex
#		mdt.set_vertex(i, vert)

#	transform.origin = global_transform.origin + Vector3(0,0,0.471)
	
	mesh.surface_remove(0) # Deletes the first surface of the mesh.
	mdt.commit_to_surface(mesh)
	
#	ResourceSaver.save("res://scenes/pooka/models/new-pumpkin_mesh.tres", mesh)
