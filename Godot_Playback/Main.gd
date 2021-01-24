extends Node

var iTOW:int = 0
var iTOWstartTicks_msec:int
var iTOWStart:int = 10170000
var iTOWEnd:int =   10551000
#var iTOWEnd:int = 1000 * 60 * 60 * 24 * 7	# Max possible ITOW value

# The following can be used to generate synced videos so that the frames
# generated will be at the same time stamps ("quantum").
# Can be used to generate synced alpha mask video for example.
# 0 or huge value (>= 1000, meaning 1 ms frame time) = disable
export(float, 0, 1000) var fps:float = 0
#export(float, 0.001, 100) var replaySpeed:float = 1

var visibilityScriptIndex:int = 0
var dataSetIndexInUse:int = 0

const numOfLidarObjectPointSets:int = 51
const minLidarPointSetTime:int = 100
var lidarObjectPointSets = []
var currentObjectPointSet:int = 0
var currentObjectPointSetLowerRangeITOW:int = -1

var previousReplaySpeed:float = 1
var requestReplayRestart:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var LidarObjectPoints = load("LidarObjectPoints.gd")
	
	for i in range(0, numOfLidarObjectPointSets):
		lidarObjectPointSets.append(LidarObjectPoints.new())
		add_child(lidarObjectPointSets[i])
	requestReplayRestart = true

	_on_HSlider_Transparency_value_changed($Panel_UIControls/HSlider_Transparency.value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# (delta not used here to get better sync when generating video)
func _process(_delta):
	var uptime:int = OS.get_ticks_msec()
	camSwitch()
	handleScriptPlaybackControls()

	if (requestReplayRestart):
		iTOWstartTicks_msec = uptime
		requestReplayRestart = false

	if Input.is_action_just_pressed("full_screen_toggle"):
		OS.window_fullscreen = !OS.window_fullscreen

	if Input.is_action_just_pressed("hide_controls"):
		var show = !get_node("Panel_ShowControls").visible
		get_node("Panel_ShowControls").visible = show

	if get_tree().paused:
		return
	
	var replaySpeed:float = get_node("Panel_UIControls/SpinBox_ReplaySpeed").value
	if (replaySpeed != previousReplaySpeed):
		# Calculate start time "backwards" so that the replay stays continuous
		iTOWstartTicks_msec = int(uptime - (uptime - iTOWstartTicks_msec) * (previousReplaySpeed / replaySpeed))
		previousReplaySpeed = replaySpeed

	while (uptime - iTOWstartTicks_msec < 0):
		# Bit rude way to fix "rewind before the start of times", but works...
		iTOWstartTicks_msec += (iTOWStart - iTOWEnd)
	
	if (fps == 0):
		iTOW = iTOWStart + (int(((uptime - iTOWstartTicks_msec) * replaySpeed)) % (iTOWStart - iTOWEnd))
	else:
		var frameIndex:int = int(int((uptime - iTOWstartTicks_msec + 1) + (500.0 / fps)) * fps / 1000)
		iTOW = iTOWStart + int((frameIndex * 1000.0 / fps) * replaySpeed) % (iTOWStart - iTOWEnd) 
		#print(frameIndex)
	
	if ((iTOW - currentObjectPointSetLowerRangeITOW < 1000) and (currentObjectPointSetLowerRangeITOW <= iTOW)):
		lidarObjectPointSets[currentObjectPointSet].setViewRange(currentObjectPointSetLowerRangeITOW, iTOW)
		if (iTOW - currentObjectPointSetLowerRangeITOW >= minLidarPointSetTime):
			# Switch to next point set only when points have been added from adequate time period
			# This prevents creating of too small point sets when replay speed is slow
			# which, consequently would lead to huge amounts of pointsets, slowing everything down
			currentObjectPointSet = (currentObjectPointSet + 1) % numOfLidarObjectPointSets
			currentObjectPointSetLowerRangeITOW = iTOW + 1
	else:
		currentObjectPointSetLowerRangeITOW = iTOW

func camSwitch():
	if Input.is_action_pressed("camera_1"):
		var firstPerson = get_node("FirstPerson")
		var flyCamera = get_node("FirstPerson/Head/FirstPersonCamera")
		firstPerson.set_LocationOrientation(get_viewport().get_camera().get_global_transform())
#		var rigCamera = get_node("LOSolver_CameraEye/RigCamera")
#		if (get_viewport().get_camera() == rigCamera):
			# Sync initial location and orientation of the fly camera with the rgis camera
#			firstPerson.set_LocationOrientation(rigCamera.get_global_transform())
		flyCamera.current = true
	if Input.is_action_pressed("camera_2"):
#		var camera = get_node("LOSolver_CameraRig/RigCamera")
		var camera = get_node("LOSolver_CameraEye/RigCamera")
		camera.current = true
	if Input.is_action_pressed("camera_3"):
		var camera = get_node("LOSolver_CameraRig/BackCamera")
		camera.current = true
#	if Input.is_action_pressed("camera_4"):
#		var camera = get_node("ToiletRotator/Camera")
#		camera.current = true

func handleScriptPlaybackControls():
	if Input.is_action_just_pressed("rewind_5s"):
		iTOWstartTicks_msec = iTOWstartTicks_msec + 5000
	if Input.is_action_just_pressed("fast_forward_5s"):
		iTOWstartTicks_msec = iTOWstartTicks_msec - 5000
	if Input.is_action_pressed("resetITOW"):
		requestReplayRestart = true


func _on_Button_LoadLidarScript_pressed():
	$LidarDataStorage.loadFile("res://GNSS_Stylus_Scripts/HareScan2_LidarScript.godot_compressed", $LidarDataStorage.CompressionMode.DEFLATE)
	$Panel_LoadLidarScript_Confirmation.visible = false

func _on_Button_ClearLidarScript_pressed():
	$LidarDataStorage.clearData()
	$LidarLines.clear()
	$Panel_LoadLidarScript_Confirmation.visible = false

func _on_Button_LoadClearLidarScript_pressed():
	$Panel_LoadLidarScript_Confirmation.visible = true

func _on_Button_CancelLidarScriptOperation_pressed():
	$Panel_LoadLidarScript_Confirmation.visible = false

func _on_HSlider_Transparency_value_changed(value):
	var material:SpatialMaterial = $HareScan2_Textured.get_child(0).get_surface_material(0)
	if (value >= 256):
		material.flags_transparent = false
		material.albedo_color.a8 = 255
	else:
		material.flags_transparent = true
		material.albedo_color.a8 = value
		


func _on_CheckBox_ShowHelp_toggled(button_pressed):
	$Panel_Help.visible = button_pressed
