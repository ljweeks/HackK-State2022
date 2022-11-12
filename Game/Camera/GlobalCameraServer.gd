extends Node


const PREVIEW_COOLDOWN := 0.1


var preview_image: ImageTexture = null
var preview_frame: Dictionary = {}
var last_preview: float = 0.0

var preview_image_complete := true
var preview_frame_complete := true

var server_recording := false

var recording_images: Array = []
var recording_frames: Array = []

signal record_finished(images, frames)


func get_preview_image() -> ImageTexture:
	return preview_image

func get_preview_frame() -> Dictionary:
	return preview_frame

func start_record() -> void:
	$StartRecordRequest.request("http://127.0.0.1:8080/record/start")

func end_record() -> void:
	$EndRecordRequest.request("http://127.0.0.1:8080/record/end")

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
			preview_image_complete = false
		if preview_frame_complete:
			var error = $PreviewFrameRequest.request("http://127.0.0.1:8080/preview/frame")
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
	if response_code == 200:
		server_recording = true
		recording_images = []
		recording_frames = []

func _end_record_complete(results, response_code, headers, body):
	if response_code == 200:
		server_recording = false
		$RecordFramesRequest.request("http://127.0.0.1:8080/record/frames")

func _record_image_complete(results, response_code, headers, body):
	if response_code == 200:
		recording_images.push_back(_texture_from_bytes(body))
		if recording_images.size() < recording_frames.size():
			$RecordImageRequest.request("http://127.0.0.1:8080/record/image/" + str(recording_images.size()))
		else:
			emit_signal("record_finished", recording_images, recording_frames)

func _record_frames_complete(results, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse(body.get_string_from_utf8())
		recording_frames = json.result
		recording_images = []
		$RecordImageRequest.request("http://127.0.0.1:8080/record/image/0")
