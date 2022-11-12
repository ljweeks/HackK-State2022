from flask import Flask
import json
import cv2
import mediapipe as mp
import numpy as np
import threading
import atexit
from recording import Recording
import time
from pygrabber.dshow_graph import FilterGraph

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_pose = mp.solutions.pose

# === WEBCAM PARAMETERS ===

# Which webcam to use
webcam = "c922"
# Which webcam driver to use
driver = cv2.CAP_DSHOW

# === MODEL PARAMETERS ===

# See MediaPipe documentation
model_complexity = 2
min_detection_confidence = 0.5
min_tracking_confidence = 0.5
smooth_segmentation = True

# === RECORDING PARAMETERS ===
frame_rate = 10
max_frames = frame_rate * 3

# Thread reading camera data and running AI
camera_thread = threading.Thread()
# Lock to control access to data
camera_lock = threading.Lock()
# Recording data. Should only be accessed when we have the camera lock.
recording = Recording()


# Transforms an image by masking out everything above a threshold on the mask
def mask_image(image, mask):
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGBA)
    condition = False
    if mask is not None:
        condition = np.stack((mask,) * 4, axis=-1) > 0.1
    bg_image = np.zeros(image.shape, dtype=np.uint8)
    bg_image[:] = (0, 0, 0, 0)
    return np.where(condition, image, bg_image)


# Generates the data for a frame
def generate_framedata(image, landmarks):
    bone_defs = {
        'left_arm_end': [16, 14],
        'left_arm_base': [14, 12],
        'right_arm_end': [15, 13],
        'right_arm_base': [13, 11],
        'chest_upper': [12, 11],
        'chest_right': [11, 23],
        'chest_left': [12, 24],
        'chest_lower': [24, 23],
        'left_leg_base': [24, 26],
        'left_leg_end': [26, 28],
        'right_leg_base': [23, 25],
        'right_leg_end': [25, 27],
        'left_head': [12, 5],
        'right_head': [11, 2]
    }
    damage_point_defs = {
        'left_hand': 16,
        'right_hand': 15,
        'left_foot': 28,
        'right_foot': 27
    }

    points = None
    if landmarks is not None:
        points = landmarks.landmark

    height, width, _ = image.shape

    # Get position of each bone
    bones = {}
    for name, indexes in bone_defs.items():
        if landmarks is not None:
            landmark_0 = points[indexes[0]]
            landmark_1 = points[indexes[1]]
            bones[name] = {
                'x1': landmark_0.x * width,
                'y1': landmark_0.y * height,
                'x2': landmark_1.x * width,
                'y2': landmark_1.y * height
            }
        else:
            bones[name] = {
                'x1': 0,
                'y1': 0,
                'x2': 0,
                'y2': 0
            }

    # Get position of each damage point
    damage_points = {}
    for name, index in damage_point_defs.items():
        if landmarks is not None:
            landmark = points[index]
            damage_points[name] = {
                'x': landmark.x,
                'y': landmark.y
            }
        else:
            damage_points[name] = {
                'x': 0,
                'y': 0
            }

    return {
        'character_colliders': bones,
        'hurtboxes': damage_points
    }


# Encodes an OpenCV image into a list of bytes
def encode_image(image):
    _, img_encoded = cv2.imencode('.png', image)
    return img_encoded.tobytes()


# Returns the OpenCV index of the first camera with a name containing the given filter
def camera_index(name):
    graph = FilterGraph()
    for idx, device in enumerate(graph.get_input_devices()):
        if name in device:
            return idx
    return 0


webcam_index = camera_index(webcam)


# Flask application
def create_app():
    app = Flask(__name__)

    # Kill the camera thread on exit
    def on_exit():
        global camera_thread
        global camera_lock
        global recording
        with camera_lock:
            recording.kill = True
        camera_thread.join()

    # Capture camera data in a loop
    def camera_loop():
        global camera_lock
        global recording

        # Initialize video capture
        cap = cv2.VideoCapture(webcam_index, driver)


        # Initialize mediapipe model
        with mp_pose.Pose(
                model_complexity=model_complexity,
                min_detection_confidence=min_detection_confidence,
                min_tracking_confidence=min_tracking_confidence,
                enable_segmentation=True,
                smooth_segmentation=smooth_segmentation) as pose:
            # Read each camera frame
            killed = False
            prev = time.time()
            while cap.isOpened() and not killed:
                # Get elapsed time
                curr = time.time()
                time_elapsed = time.time() - prev
                prev = curr

                # Read frame
                success, image = cap.read()
                if not success:
                    continue

                # Convert image into color
                image.flags.writeable = False
                image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

                # Process image in mediapipe model
                results = pose.process(image)

                # Save data to the recording
                with camera_lock:
                    killed = recording.kill
                    recording.preview_image = mask_image(image, results.segmentation_mask)
                    recording.preview_frame = generate_framedata(image, results.pose_landmarks)

                    if recording.started and time_elapsed > 1.0 / frame_rate and recording.recording_len() < max_frames:
                        recording.record_preview()

        # Release camera
        cap.release()

    # Initialize camera thread
    global camera_thread
    camera_thread = threading.Thread(target=camera_loop)
    camera_thread.start()

    # Register exist
    atexit.register(on_exit)

    return app


app = create_app()


@app.route("/preview/image")
def get_preview_image():
    global camera_lock
    global recording
    with camera_lock:
        return encode_image(recording.preview_image)


@app.route("/preview/frame")
def get_preview_frame():
    global camera_lock
    global recording
    with camera_lock:
        return json.dumps(recording.preview_frame)


@app.route("/record/start")
def start_record():
    global camera_lock
    global recording
    with camera_lock:
        recording.clear()
        recording.started = True
    return ""


@app.route("/record/end")
def end_record():
    global camera_lock
    global recording
    with camera_lock:
        recording.started = False
    return ""


@app.route("/record/frames")
def get_recorded_frames():
    global camera_lock
    global recording
    with camera_lock:
        return json.dumps(recording.recorded_frames)


@app.route("/record/image/<index>")
def get_recorded_image(index=0):
    global camera_lock
    global recording
    with camera_lock:
        return encode_image(recording.recorded_images[int(index)])


app.run(port=8080, threaded=True)
