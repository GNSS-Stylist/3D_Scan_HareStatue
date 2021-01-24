extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const groundLevel = -0.15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var loSolverObject = get_node("../LOSolver_Object")
	var newTranslation = loSolverObject.global_transform.origin
	newTranslation += loSolverObject.global_transform.basis.z * 0.25
	newTranslation[1] = max((1.85 - 2.0 + groundLevel), (loSolverObject.global_transform.origin.y - 2.0 + 0.05))
#	newTranslation[1] = transform.origin[1]
	global_transform.origin = newTranslation
