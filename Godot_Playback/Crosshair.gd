extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var camera = get_node("../Head/FirstPersonCamera")
	if camera.current:
		var center = get_viewport_rect().size
		self.position = center / 2
		self.visible = true
	else:
		self.visible = false
