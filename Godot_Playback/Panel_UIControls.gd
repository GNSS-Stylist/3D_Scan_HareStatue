extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_node("../LOSolver_CameraRig/GreenScreen").visible = get_node("CheckBox_GreenScreen").pressed
	get_node("../Ground").visible = get_node("CheckBox_Ground").pressed
