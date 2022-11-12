import numpy as np


# Represents a recording in progress
class Recording:
    preview_image = np.zeros((8, 8, 3), dtype=np.uint8)
    preview_frame = {}

    started = False

    recorded_images = []
    recorded_frames = []

    kill = False

    # Clears out data from the current recording
    def clear(self):
        self.recorded_images.clear()
        self.recorded_frames.clear()
        self.started = False
