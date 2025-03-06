extends Node3D

var most_recent_star: Node3D
var stars: Array[Node3D] = []
var lines: Array

@export var answer: Array[Node3D]
@export var answer2: Array[Array]

@onready var rev_answer = answer.duplicate()

var is_solved = false

func _ready() -> void:
	stars.clear()
	rev_answer.reverse()

func _physics_process(_delta: float) -> void:
	if is_solved == false: 
		
		#print("Rot ",is_rotation_solved()," | Sta ",is_sequence_solved())
		#print()
		
		if is_rotation_solved() && is_sequence_solved():
			solve()

func is_sequence_solved() -> bool:
	return (stars == answer || stars == rev_answer)

func is_rotation_solved() -> bool:
	var rotator_forward: Vector3 = get_child(0).transform.basis.z
	var rotator_right: Vector3 = get_child(0).transform.basis.x
	
	var tolarance = 20
	if rotator_forward.angle_to(Vector3.BACK) < deg_to_rad(tolarance) && rotator_right.angle_to(Vector3.RIGHT) < deg_to_rad(tolarance):
		return true
	return false

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.pressed == false && Singleton.active_state == Singleton.State.CONSTELLATION_TRACING:
			Singleton.active_state = Singleton.State.CONSTELLATION_DEFAULT

func solve():
	if is_solved:
		return
	
	print("solved")
	Singleton.audio_manager.play_twinkle()
	
	Singleton.active_state = Singleton.State.NO_TARGET
	get_child(0).process_mode = Node.PROCESS_MODE_DISABLED
	Singleton.star_cluster = null
	Singleton.next_constellation()
	is_solved = true
	
	var initial_rotation = Quaternion(get_child(0).transform.basis)
	var final_rotation = Quaternion.IDENTITY
	
	var seconds = 0.3
	var total_i = seconds * 60
	for i in total_i:
		
		var t = i / float(total_i)
		var te = ease(t,1)
		
		var new_rotation = initial_rotation.slerp(final_rotation, te)
		
		get_child(0).transform.basis = Basis(new_rotation)
		
		await get_tree().create_timer(1.0/60.0).timeout
	
	Singleton.camera.focus_out()

func reset_selection():
	for s in stars:
		s.deselect()
	
	stars.clear()
	clear_line()

func start_selection(star: Node3D):
	reset_selection()
	stars.append(star)
	most_recent_star = star

func add_to_selection(star: Node3D):
	if most_recent_star == star:
		return
	stars.append(star)
	most_recent_star = star
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
	
	get_child(0).add_child(mesh_instance)
	
	var angle = (point2 - point1).angle_to(Vector3.UP)
	var axis = (point2 - point1).cross(Vector3.UP).normalized()
	if axis != Vector3.ZERO:
		mesh_instance.rotate(-axis, angle)
	
	return mesh_instance
