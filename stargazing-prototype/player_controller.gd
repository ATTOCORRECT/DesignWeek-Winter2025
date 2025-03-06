extends Node



@onready var SCREEN_SIZE = get_viewport().get_visible_rect().size

var dragging = false
var drag_roll = false
var drag_position = Vector2.ZERO
var drag_position_offset = Vector2.ZERO
var drag_roll_position = 0.0
var drag_roll_position_offset = 0.0

var is_zoomed = false
var is_zoom_animating = false

func _input(event):
	if Singleton.active_state == Singleton.State.GAZING:
		gazing_controlls(event)
	
	if Singleton.active_state == Singleton.State.CONSTELLATION_ALIGNMENT || Singleton.active_state == Singleton.State.CONSTELLATION_TRACING || Singleton.active_state == Singleton.State.CONSTELLATION_DEFAULT:
		constellation_controlls(event)
	
	#if event.is_action_pressed("ui_up"):
		#Singleton.star_cluster.solve()
	#
	#if event.is_action_pressed("ui_down"):
		#Singleton.camera.focus_out()
	
	if event.is_action_pressed("zoom_in"):
		zoom_in()
	
	if Singleton.active_state != Singleton.State.GAZING:
		if event.is_action_pressed("zoom_out") && !is_zoom_animating:
			dragging = false
			is_zoomed = false
			Singleton.camera.zoom_out()
			$"../World/Telescope/Telescope Model".visible = true
			$"../UI/TextureRect".visible = false
			
			Singleton.telescope.rotation_degrees.x -= 5

func zoom_in():
	if is_zoomed:
		return
	
	dragging = false
	is_zoomed = true
	Singleton.camera.zoom_in()
	$"../World/Telescope/Telescope Model".visible = false
	$"../UI/TextureRect".visible = true
	
	Singleton.telescope.rotation_degrees.x += 5
	
	if Singleton.telescope.rotation_degrees.x < 5:
		Singleton.telescope.rotation_degrees.x = 5
	
	if Singleton.star_cluster == null:
		return
	
	var telescope_direction = rotation_to_direction(Singleton.telescope.rotation)
	var stars_direction = rotation_to_direction(Singleton.star_cluster.rotation)
	
	var min_angle = telescope_direction.angle_to(stars_direction)
	
	if rad_to_deg(min_angle) < 10:
		focus()

func focus():
	is_zoom_animating = true
	
	var telescope_rotation = Singleton.telescope.rotation
	var stars_rotation = Singleton.star_cluster.rotation
	
	var seconds = 0.3
	var total_i = seconds * 60
	for i in total_i:
		
		var t = i / float(total_i)
		var te = ease(t,-5)
		
		Singleton.telescope.rotation = lerp(telescope_rotation, stars_rotation, te)
		
		await get_tree().create_timer(1.0/60.0).timeout
	
	Singleton.camera.focus_in()
	
	await get_tree().create_timer(0.5).timeout
	is_zoom_animating = false


func gazing_controlls(event):
	if event is InputEventMouseButton:
		# Mouse 1 pressed
		if event.is_action_pressed("press"):
			
			var position = telescope_normalized_screen_position(event.position)
			
			dragging = true
			drag_position = position
		
		if event.is_action_released("press"):
			dragging = false
	
	if event is InputEventMouseMotion:
		if dragging:
			var position = telescope_normalized_screen_position(event.position)
			
			drag_position_offset = drag_position - position
			
			if drag_position_offset != Vector2.ZERO:
				drag_position = position

				Singleton.telescope.rotate_y(drag_position_offset.x * -0.8)
				Singleton.telescope.rotate_object_local(Vector3.LEFT,drag_position_offset.y * 0.8)

func constellation_controlls(event):
		# Mouse pressed
	if event is InputEventMouseButton:
		# Mouse 1 pressed
		if event.is_action_pressed("press") && Singleton.active_state == Singleton.State.CONSTELLATION_DEFAULT:
			Singleton.active_state = Singleton.State.CONSTELLATION_ALIGNMENT
			
			var position = telescope_normalized_screen_position(event.position)
			var centered_position = position * 2 - Vector2.ONE
			var roll_position = atan2(centered_position.x,centered_position.y)
			
			dragging = true
			drag_position = position
			
			drag_roll_position = roll_position
			
			drag_roll = true
			# Mouse within telescope
			if centered_position.length() < 1024.0 / 1080.0:
				drag_roll = false
		
		if event.is_action_released("press"):
			Singleton.active_state = Singleton.State.CONSTELLATION_DEFAULT
			dragging = false
	
	if event is InputEventMouseMotion && Singleton.active_state == Singleton.State.CONSTELLATION_ALIGNMENT:
		if dragging:
			if drag_roll:
				var position = telescope_normalized_screen_position(event.position)
				var centered_position = position * 2 - Vector2.ONE
				var roll_position = atan2(centered_position.x,centered_position.y)
				
				drag_roll_position_offset = drag_roll_position - roll_position
				
				if drag_roll_position_offset != 0:
					drag_roll_position = roll_position
					
					Singleton.star_cluster.get_child(0).rotate(Vector3.FORWARD,drag_roll_position_offset)
			else:
				var position = telescope_normalized_screen_position(event.position)
				
				drag_position_offset = drag_position - position
				
				if drag_position_offset != Vector2.ZERO:
					drag_position = position

					Singleton.star_cluster.get_child(0).rotate(Vector3.DOWN,drag_position_offset.x * 2)
					Singleton.star_cluster.get_child(0).rotate(Vector3.LEFT,drag_position_offset.y * 2)

func telescope_normalized_screen_position(event_position : Vector2) -> Vector2:
	var centered_event_position = event_position - Vector2.RIGHT * 0.5 * (SCREEN_SIZE.x - SCREEN_SIZE.y)
	var position = centered_event_position / SCREEN_SIZE.y
	return position

func rotation_to_direction(rotation) -> Vector3:
	return Vector3(sin(rotation.x) * cos(rotation.y), 
				   cos(rotation.x),
				   sin(rotation.x) * sin(rotation.y))
