extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var iTOWShift:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var dataStorage = get_node("/root/Main/LidarDataStorage")
	if (dataStorage.beamData.size() == 0):
		return
	
	var currentITOW:int = get_node("/root/Main").iTOW + iTOWShift
	var itemIndex:int = dataStorage.beamDataKeys.bsearch(currentITOW, true)

#	if (dataStorage.Beam)

	if (itemIndex < dataStorage.beamDataKeys.size()):
		var subItem = dataStorage.beamData[dataStorage.beamDataKeys[itemIndex]].back()
		self.rotation = Vector3(subItem.rotation, 0,0)
