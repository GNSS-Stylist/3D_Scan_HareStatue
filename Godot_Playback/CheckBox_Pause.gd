extends CheckBox

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pauseStartTime

# Called when the node enters the scene tree for the first time.
func _ready():
	pauseStartTime = OS.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		self.pressed = !self.pressed
		
	if self.pressed:
		if not get_tree().paused:
			pauseStartTime = OS.get_ticks_msec()
			get_tree().set_pause(not get_tree().paused)
	else:
		if get_tree().paused:
			get_tree().set_pause(false)
			# Animation is synced to ms ticks counted by "main" node.
			# Therefore we need to adjust time to get real pause.
			# (ms tics used to get recorded video better into sync)
			var mainNode = get_node("/root/Main")
			mainNode.iTOWstartTicks_msec = mainNode.iTOWstartTicks_msec + OS.get_ticks_msec() - pauseStartTime
