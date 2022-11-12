from flask import Flask
import json
import cv2
import mediapipe as mp
import numpy as np
import threading
import atexit
from recording import Recording

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_pose = mp.solutions.pose

# === WEBCAM PARAMETERS ===

# Which webcam to use
webcam = 1
# Which webcam driver to use
driver = cv2.CAP_DSHOW

# === MODEL PARAMETERS ===

# See MediaPipe documentation
model_complexity = 2
min_detection_confidence = 0.5
min_tracking_confidence = 0.5
smooth_segmentation = True

# Thread reading camera data and running AI
camera_thread = threading.Thread()
# Lock to control access to data
camera_lock = threading.Lock()
# Recording data. Should only be accessed when we have the camera lock.
recording = Recording()


# Transforms an image by masking out everything above a threshold on the mask
def mask_image(image, mask):
    condition = False
    if mask is not None:
        condition = np.stack((mask,) * 3, axis=-1) > 0.1
    bg_image = np.zeros(image.shape, dtype=np.uint8)
    bg_image[:] = (1, 1, 1)
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

    # Get position of each bone
    bones = {}
    for name, indexes in bone_defs.items():
        if landmarks is not None:
            landmark_0 = points[indexes[0]]
            landmark_1 = points[indexes[1]]
            bones[name] = {
                'x1': landmark_0.x,
                'y1': landmark_0.y,
                'x2': landmark_1.x,
                'y2': landmark_0.y
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
        cap = cv2.VideoCapture(webcam, driver)

        # Initialize mediapipe model
        with mp_pose.Pose(
                model_complexity=model_complexity,
                min_detection_confidence=min_detection_confidence,
                min_tracking_confidence=min_tracking_confidence,
                enable_segmentation=True,
                smooth_segmentation=smooth_segmentation) as pose:
            # Read each camera frame
            killed = False
            while cap.isOpened() and not killed:
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
        return "<p>Hello, World!</p>"


@app.route("/record/end")
def end_record():
    global camera_lock
    global recording
    with camera_lock:
        return "<p>Hello, World!</p>"


@app.route("/record/frames")
def get_recorded_frames():
    global camera_lock
    global recording
    with camera_lock:
        return "<p>Hello, World!</p>"


@app.route("/record/image")
def get_recorded_image():
    global camera_lock
    global recording
    with camera_lock:
        return "<p>Hello, World!</p>"


app.run(port=8080, threaded=True)
