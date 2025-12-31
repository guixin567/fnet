import 'package:dio/dio.dart';

/// Response decoder interface.
/// Converts Response to target type.
abstract class NetDecoder {
  /// Decode response to target type.
  ///
  /// - [response] - The HTTP response
  /// - [fromJsonFunc] - Optional JSON deserializer function
  /// - `T` - Model type
  /// - `K` - Return type (can be T or List of T)
  K decode<T, K>({
    required Response<dynamic> response,
    T? Function(dynamic)? fromJsonFunc,
  });
}
