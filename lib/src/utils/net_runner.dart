import 'package:flutter/foundation.dart';

/// A utility class for running heavy tasks in an isolate.
/// Abstracts Flutter's [compute] function to allow for easier portability.
class NetRunner {
  /// Run a function in an isolate if data is large.
  static Future<R> run<Q, R>(ComputeCallback<Q, R> callback, Q message) async {
    // In Flutter, we use the compute function.
    // In pure Dart, this could be replaced with Isolate.run or similar.
    return await compute(callback, message);
  }

  /// Whether the app is running in debug mode.
  static bool get isDebug => kDebugMode;
  
  /// Whether the app is running on Web.
  static bool get isWeb => kIsWeb;
}
