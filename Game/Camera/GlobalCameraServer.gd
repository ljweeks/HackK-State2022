extends Node


const PREVIEW_COOLDOWN := 0.1


var preview_image: ImageTexture = null
var preview_frame: Dictionary = {}
var last_preview: float = 0.0

var preview_image_complete := true
var preview_frame_complete := true


signal record_finished(sheet, frames)


func get_preview_image() -> ImageTexture:
	return preview_image

func get_preview_frame() -> Dictionary:
	return preview_frame

func start_record() -> void:
	pass

func end_record() -> void:
	pass

func _texture_from_bytes(bytes) -> ImageTexture:
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load_png_from_buffer(bytes)
	texture.create_from_image(image)
	return texture

func _ready():
	$PreviewImageRequest.connect("request_completed", self, "_preview_image_complete")
	$PreviewFrameRequest.connect("request_completed", self, "_preview_frame_complete")
	$StartRecordRequest.connect("request_completed", self, "_start_record_complete")
	$EndRecordRequest.connect("request_completed", self, "_end_record_complete")
	$RecordImageRequest.connect("request_completed", self, "_record_image_complete")
	$RecordFramesRequest.connect("request_completed", self, "_record_frames_complete")

func _process(delta):
	last_preview += delta
	if last_preview >= PREVIEW_COOLDOWN:
		if preview_image_complete:
			var error = $PreviewImageRequest.request("http://127.0.0.1:8080/preview/image")
			print(error)
			preview_image_complete = false
		if preview_frame_complete:
			var error = $PreviewFrameRequest.request("http://127.0.0.1:8080/preview/frame")
			print(error)
			preview_frame_complete = false
		last_preview = 0.0

func _preview_image_complete(result, response_code, headers, body):
	if response_code == 200:
		preview_image = _texture_from_bytes(body)
	preview_image_complete = true

func _preview_frame_complete(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse(body.get_string_from_utf8())
		preview_frame = json.result
	preview_frame_complete = true

func _start_record_complete(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)

func _end_record_complete(results, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)

func _record_image_complete(results, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)

func _record_frames_complete(results, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
