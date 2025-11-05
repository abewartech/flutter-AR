# TensorFlow Lite Setup Guide

This guide explains how to set up TensorFlow Lite for face detection in the AR Avatar Camera app.

## Overview

The app now includes TensorFlow Lite integration for real-time face detection. The implementation includes:

- **TFLite Face Detection Service** (`lib/core/services/tflite_face_detection_service.dart`)
- **Automatic fallback** to mock detection if TFLite model is not available
- **Real-time camera frame processing** for face detection

## Current Status

The TFLite service is integrated but **requires a face detection model file** to function. Currently, the app will automatically fall back to mock detection until you add a model.

## Step 1: Get a Face Detection Model

You need a TensorFlow Lite model file (`.tflite`) for face detection. Recommended options:

### Option A: BlazeFace (Recommended - Lightweight & Fast)
- **Source**: [MediaPipe BlazeFace](https://github.com/google/mediapipe)
- **Size**: ~1-2 MB
- **Speed**: Very fast, optimized for mobile
- **Accuracy**: Good for real-time applications

### Option B: MTCNN
- **Source**: Various TensorFlow Lite conversions
- **Size**: ~2-3 MB
- **Speed**: Moderate
- **Accuracy**: Higher accuracy than BlazeFace

### Option C: Custom Model
- Train or convert your own face detection model to TensorFlow Lite format

## Step 2: Add Model to Assets

1. Create a `models` directory in your `assets` folder:
   ```
   assets/
   └── models/
       └── face_detection.tflite
   ```

2. Update `pubspec.yaml` to include the models directory:
   ```yaml
   flutter:
     assets:
       - assets/
       - assets/images/
       - assets/models/  # Add this line
   ```

3. Run `flutter pub get` to update assets

## Step 3: Configure the Service

Open `lib/core/services/tflite_face_detection_service.dart` and update the `initialize()` method:

```dart
Future<bool> initialize({String? modelPath}) async {
  // ... existing code ...
  
  // Uncomment and configure:
  _interpreter = await Interpreter.fromAsset(
    modelPath ?? 'assets/models/face_detection.tflite',
    options: options,
  );
  
  // ... rest of initialization ...
}
```

## Step 4: Model Input/Output Format

The service expects a model with the following structure:

### Input:
- **Shape**: `[1, 320, 320, 3]` (batch, height, width, RGB channels)
- **Type**: Float32
- **Normalization**: Pixel values should be normalized (typically 0-1 or -1 to 1)

### Output:
The service expects 4 output tensors:
1. **Locations**: `[num_detections, 4]` - Bounding box coordinates (normalized 0-1)
2. **Classes**: `[num_detections]` - Class predictions
3. **Scores**: `[num_detections]` - Confidence scores (0-1)
4. **Num Detections**: `[1]` - Number of valid detections

**Note**: You may need to adjust the `_preprocessImage()` method in the service to match your specific model's requirements.

## Step 5: Test the Integration

1. Run the app: `flutter run`
2. Check the debug console for:
   - `TFLite face detection initialized successfully` - Model loaded correctly
   - `TFLite not available, using mock detection` - Model not found, using fallback

## Troubleshooting

### Model Not Loading
- Verify the file path in `pubspec.yaml`
- Ensure the `.tflite` file is in `assets/models/`
- Run `flutter clean` and `flutter pub get`
- Do a full app restart (not just hot reload)

### Wrong Input/Output Format
- Check your model's input/output shapes using TensorFlow tools
- Adjust `_inputSize` constant in the service
- Modify `_preprocessImage()` to match your model's requirements

### Performance Issues
- Use a lighter model (BlazeFace recommended)
- Reduce input image size (`_inputSize`)
- Process every Nth frame instead of every frame
- Enable GPU delegate (already included in code)

### Memory Issues
- Reduce model size
- Lower input resolution
- Process frames less frequently

## Example: Using BlazeFace

If using BlazeFace model:

1. Download the model from MediaPipe or convert from TensorFlow
2. Place it as `assets/models/blazeface.tflite`
3. Update the service initialization:
   ```dart
   _interpreter = await Interpreter.fromAsset(
     'assets/models/blazeface.tflite',
     options: options,
   );
   ```
4. Adjust preprocessing if needed based on BlazeFace's specific requirements

## Additional Resources

- [TensorFlow Lite Documentation](https://www.tensorflow.org/lite)
- [tflite_flutter Package](https://pub.dev/packages/tflite_flutter)
- [MediaPipe Face Detection](https://github.com/google/mediapipe)
- [Converting Models to TFLite](https://www.tensorflow.org/lite/models/convert)

## Current Implementation Notes

- The service automatically falls back to mock detection if no model is available
- Detection runs on camera frames in real-time
- Confidence threshold is set to 0.5 (adjustable in `_confidenceThreshold`)
- Maximum detections: 10 faces (adjustable in `_numDetections`)

