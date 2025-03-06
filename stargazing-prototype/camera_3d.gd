extends Camera3D

var is_zoomed = true
var is_focused = true

var is_animating = false

var in_z = 0
var out_z = 100
var gaze_z = 0

var in_fwidth = 2.0
var gaze_fov = 75

var in_near = 0.001
var out_near = 100
var gaze_near = 0.001

func focus_in():
	if is_focused || is_animating:
		return
	is_animating = true
	
	var seconds = 0.3
	var total_i = seconds * 60
	for i in total_i:
		
		var t = i / float(total_i)
		var te = ease(t,1)
		
		self.position.z = lerpf(out_z, in_z, ease(te,1/5.0))
		
		var new_in_fov = rad_to_deg(atan(in_fwidth / (8.0 + position.z))) * 2
		
		self.fov = new_in_fov
		self.near = lerpf(out_near, in_near, ease(te,1/5.0))
		
		await get_tree().create_timer(1.0/60.0).timeout
	
	set_focus_in_settings()
	print("focus in")
	is_animating = false

func focus_out():
	if !is_focused || is_animating:
		return
	is_animating = true
	
	var seconds = 0.3
	var total_i = seconds * 60
	for i in total_i:
		
		var t = i / float(total_i)
		var te = ease(t,1)
		
		self.position.z = lerpf(in_z, out_z, ease(te,5.0))
		
		var new_in_fov = rad_to_deg(atan(in_fwidth / (8.0 + position.z))) * 2
		
		self.fov = new_in_fov
		self.near = lerpf(in_near, out_near, ease(te,5.0))
		
		await get_tree().create_timer(1.0/60.0).timeout
	
	set_focus_out_settings()
	print("focus out")
	is_animating = false

func zoom_in():
	set_zoom_in_settings()
	print("zoom in")


func zoom_out():
	set_zoom_out_settings()
	print("zoom out")
	Singleton.audio_manager.play_layer()


func set_focus_in_settings():
	self.position.z = in_z
	self.fov = rad_to_deg(atan(in_fwidth / (8.0 + position.z))) * 2
	self.near = in_near
	
	is_focused = true
	Singleton.active_state = Singleton.State.CONSTELLATION_DEFAULT

func set_focus_out_settings():
	self.position.z = out_z
	self.fov = rad_to_deg(atan(in_fwidth / (8.0 + position.z))) * 2
	self.near = out_near
	
	is_focused = false
	is_zoomed = true
	Singleton.active_state = Singleton.State.NO_TARGET

func set_zoom_in_settings():
	set_focus_out_settings()

func set_zoom_out_settings():
	self.position.z = gaze_z
	self.fov = gaze_fov
	self.near = gaze_near
	
	is_zoomed = false
	Singleton.active_state = Singleton.State.GAZING
