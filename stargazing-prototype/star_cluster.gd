extends Node3D

var stars: Array[Node3D] = []
var lines: Array

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.pressed == false && Singleton.active_state == Singleton.State.CONSTELATION_TRACING:
			Singleton.active_state = Singleton.State.DEFAULT

func reset_selection():
	for s in stars:
		s.deselect()
	
	stars.clear()
	clear_line()

func start_selection(star: Node3D):
	reset_selection()
	stars.append(star)

func add_to_selection(star: Node3D):
	stars.append(star)
	update_line()

func update_line():
	clear_line()
		
	if stars.size() < 2:
		return
	
	for i in stars.size() - 1:
		lines.append(line(stars[i].position, stars[i + 1].position))
		pass

func clear_line():
	for l in lines:
		l.queue_free()
	lines.clear()

func line(point1: Vector3, point2: Vector3) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var line_mesh = CapsuleMesh.new()
	var material = StandardMaterial3D.new()
	
	mesh_instance.mesh = line_mesh
	mesh_instance.cast_shadow = false
	mesh_instance.position = (point1 + point2) / 2
	
	line_mesh.radius = 0.005
	line_mesh.height = (point2 - point1).length()
	line_mesh.material = material
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.GOLD
	
	add_child(mesh_instance)
	
	var angle = (point2 - point1).angle_to(Vector3.UP)
	var axis = (point2 - point1).cross(Vector3.UP).normalized()
	if axis != Vector3.ZERO:
		mesh_instance.rotate(-axis, angle)
	
	return mesh_instance
