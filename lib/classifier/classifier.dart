import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

enum DetectionClasses { boxe, tennis, cyclisme, lecture }

class Classifier {
  late Interpreter _interpreter;

  static const String modelFile = 'assets/model_unquant.tflite';

  Future<void> loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            modelFile,
            options: InterpreterOptions()..threads = 4,
          );

      _interpreter.allocateTensors();
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  Interpreter get interpreter => _interpreter;

  Future<DetectionClasses> predict(img.Image image) async {
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    Float32List inputBytes = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        img.Pixel pixel = resizedImage.getPixelSafe(x, y);
        inputBytes[pixelIndex++] = pixel.r / 127.5 - 1.0;
        inputBytes[pixelIndex++] = pixel.g / 127.5 - 1.0;
        inputBytes[pixelIndex++] = pixel.b / 127.5 - 1.0;
      }
    }

    final input = inputBytes.reshape([1, 224, 224, 3]);

    final output = Float32List(1 * 4).reshape([1, 4]);

    interpreter.run(input, output);

    final predictionResult = output[0] as List<double>;
    double maxElement = predictionResult.reduce(
      (double maxElement, double element) =>
          element > maxElement ? element : maxElement,
    );
    return DetectionClasses.values[predictionResult.indexOf(maxElement)];
  }
}
