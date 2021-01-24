extends ImmediateGeometry

enum DRAWN_POINT_TYPES { all, onlyAccepted }
export (DRAWN_POINT_TYPES) var drawnPointTypes = DRAWN_POINT_TYPES.onlyAccepted

var viewTime:int = 5000
var startPointSize:float = 10
var endPointSize:float = 1
var pointsAdded:bool = false

var firstITOW:int = 945098650
var lastITOW:int = 945104778

var iTOWShift:int = 0

var myMaterial:SpatialMaterial

var LidarDataStorage = load("LidarDataStorage.gd")
var pointColors = {
	LidarDataStorage.LSItemType.ACCEPTED: Color(0, 1, 0),
	LidarDataStorage.LSItemType.REJECTED_OUTSIDE_BOUNDING_SPHERE: Color(1, 1, 0),
	LidarDataStorage.LSItemType.REJECTED_NOT_SCANNING: Color(0.5, 0.5, 0.5),
	LidarDataStorage.LSItemType.REJECTED_OBJECT_NOT_ACTIVE: Color(0.5, 0.5, 0.5),
	LidarDataStorage.LSItemType.REJECTED_ANGLE: Color(0.5, 0.5, 0.5),
# No point drawing these (or actually these draw quite funny points inside the lidar itself :) )
#	LidarDataStorage.LSItemType.REJECTED_QUALITY_PRE: Color(1, 0, 0),
#	LidarDataStorage.LSItemType.REJECTED_QUALITY_POST: Color(1, 0, 0),
	LidarDataStorage.LSItemType.REJECTED_DISTANCE_NEAR: Color(1, 0, 0),
	LidarDataStorage.LSItemType.REJECTED_DISTANCE_FAR: Color(1, 0, 0),
	LidarDataStorage.LSItemType.REJECTED_DISTANCE_DELTA: Color(1, 0, 0),
	LidarDataStorage.LSItemType.REJECTED_SLOPE: Color(1, 0, 0),
}

# Called when the node enters the scene tree for the first time.
func _ready():
#	myMaterial = self.material_override
	myMaterial = SpatialMaterial.new()
	
	myMaterial.flags_transparent = false
	myMaterial.flags_unshaded = true
	myMaterial.flags_use_point_size = true
	myMaterial.flags_do_not_receive_shadows = true
	myMaterial.flags_disable_ambient_light = true
	myMaterial.vertex_color_use_as_albedo = true
	
	myMaterial.params_point_size = 10
	
#	myMaterial.albedo_color = Color(0, 1, 0, 1)
	
	self.material_override = myMaterial
	
	pause_mode = PAUSE_MODE_STOP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var currentITOW:int = get_node("/root/Main").iTOW + iTOWShift

	if ((currentITOW - lastITOW > viewTime) or (currentITOW < lastITOW)):
		if (pointsAdded):
			clear()
			pointsAdded = false
			pause_mode = PAUSE_MODE_STOP
		return
	
	if (not pointsAdded):
		var dataStorage = get_node("../LidarDataStorage")
		if (dataStorage.beamData.size() == 0):
			return

		var itemIndex = dataStorage.beamDataKeys.bsearch(firstITOW, true)
		var lastItemIndex = dataStorage.beamDataKeys.bsearch(lastITOW, false)
		
		begin(Mesh.PRIMITIVE_POINTS)

		while ((itemIndex <= lastItemIndex) and (itemIndex < dataStorage.beamDataKeys.size())):
			for subItem in dataStorage.beamData[dataStorage.beamDataKeys[itemIndex]]:
				if ((drawnPointTypes == DRAWN_POINT_TYPES.all) or (subItem.type == LidarDataStorage.LSItemType.ACCEPTED)):
					if ((pointColors.has(subItem.type)) and (subItem.origin.distance_squared_to(subItem.hitPoint) > 0.0001)):
						set_color(pointColors[subItem.type])
						add_vertex(subItem.hitPoint)
			itemIndex += 1

		end()
		pointsAdded = true

	myMaterial.params_point_size = startPointSize - (float(currentITOW - lastITOW) / viewTime) * (startPointSize - endPointSize)


func setViewRange(firstITOW_p:int, lastITOW_p:int):
	firstITOW = firstITOW_p
	lastITOW = lastITOW_p
	clear()
	pointsAdded = false
	pause_mode = PAUSE_MODE_INHERIT
	
