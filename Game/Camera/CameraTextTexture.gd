extends TextureRect


var time = 0
var recorded = false

func _ready():
	GlobalCameraServer.start_record()

func _process(delta):
	time += delta
	if time > 2.0 and not recorded:
		recorded = true
		GlobalCameraServer.end_record()
	#texture = GlobalCameraServer.get_preview_image()
