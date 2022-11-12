extends TextureRect


func _process(delta):
	texture = GlobalCameraServer.get_preview_image()
