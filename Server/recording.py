import numpy as np


# Represents a recording in progress
class Recording:
    preview_image = np.zeros((8, 8, 4), dtype=np.uint8)
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

    # Return the length of the current recording, in frames
    def recording_len(self):
        return len(self.recorded_images)

    # Saves the current preview data to the recording
    def record_preview(self):
        self.recorded_images.append(self.preview_image)
        self.recorded_frames.append(self.preview_frame)
