import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class PlantDiseaseDetector {
  late Interpreter _interpreter;
  late List<String> _labels;
  late List<int> _inputShape;
  late List<int> _outputShape;
  final int inputSize = 200; // Match your model's expected input size
  final double mean = 127.5; // Adjust if your model uses different normalization
  final double std = 127.5;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/ml_models/model.tflite');
      final labelsData = await rootBundle.loadString('assets/ml_models/labels.txt');
      _labels = labelsData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      _inputShape = _interpreter.getInputTensor(0).shape;
      _outputShape = _interpreter.getOutputTensor(0).shape;

      print('Model loaded successfully.');
      print('Model input shape: $_inputShape');
      print('Model output shape: $_outputShape');
      print('Number of labels: ${_labels.length}');
      if (_inputShape.length == 4) {
        print('Expected input size: ${_inputShape[1]}x${_inputShape[2]}');
      }
    } catch (e) {
      print('Error loading model or labels: $e');
      rethrow;
    }
  }

  // Preprocess image: resize, normalize, convert to Float32List
  Float32List _preprocess(File imageFile) {
    try {
      final bytes = imageFile.readAsBytesSync();
      img.Image? oriImage = img.decodeImage(bytes);
      if (oriImage == null) throw Exception('Could not decode image.');
      img.Image resizedImage = img.copyResize(
        oriImage,
        width: inputSize,
        height: inputSize,
      );

      var input = Float32List(inputSize * inputSize * 3);
      int pixelIndex = 0;
      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          final pixel = resizedImage.getPixel(x, y);
          final r = pixel.r.toDouble();
          final g = pixel.g.toDouble();
          final b = pixel.b.toDouble();
          input[pixelIndex++] = (r - mean) / std;
          input[pixelIndex++] = (g - mean) / std;
          input[pixelIndex++] = (b - mean) / std;
        }
      }
      return input;
    } catch (e) {
      print('Error during image preprocessing: $e');
      rethrow;
    }
  }

  Future<String> predict(File imageFile) async {
    try {
      print('Predict called. Model expects input shape: $_inputShape, code inputSize: $inputSize');

      // Check for input size mismatch
      if (_inputShape.length == 4 &&
          (_inputShape[1] != inputSize || _inputShape[2] != inputSize)) {
        throw Exception(
            'Input size mismatch: Model expects ${_inputShape[1]}x${_inputShape[2]}, but code uses $inputSize x $inputSize. Update inputSize accordingly.');
      }

      Float32List input = _preprocess(imageFile);

      // Prepare input/output shapes
      var output = List.filled(
        _outputShape.reduce((a, b) => a * b),
        0.0,
      ).reshape([1, _labels.length]);

      print('Input buffer length: ${input.length}');
      print('Output buffer shape: ${output.length} x ${output[0].length}');

      // Run inference
      _interpreter.run(input.reshape(_inputShape), output);

      // Find the label with the highest probability
      final scores = output[0] as List<double>;
      double maxScore = scores[0];
      int maxIndex = 0;
      for (int i = 1; i < scores.length; i++) {
        if (scores[i] > maxScore) {
          maxScore = scores[i];
          maxIndex = i;
        }
      }
      final resultLabel = _labels[maxIndex];
      final confidence = (scores[maxIndex] * 100).toStringAsFixed(2);

      print('Prediction: $resultLabel ($confidence%)');
      return '$resultLabel ($confidence%)';
    } catch (e) {
      print('Error during prediction: $e');
      return 'Prediction failed: $e';
    }
  }
}
