import 'dart:io';

import 'package:fnet/fnet.dart';

/// Default decoder for network responses.
/// Parses standard API response format with code, data, and msg fields.
class DefaultNetDecoder extends NetDecoder {
  /// Singleton instance
  static final DefaultNetDecoder _instance = DefaultNetDecoder._internal();

  /// Private constructor
  DefaultNetDecoder._internal();

  /// Factory constructor to get singleton instance
  factory DefaultNetDecoder.getInstance() => _instance;

  @override
  K decode<T, K>({
    required Response<dynamic> response,
    T? Function(dynamic)? fromJsonFunc,
  }) {
    final code = response.data[paramCode];

    // Request successful (business success)
    if (code == HttpStatus.ok) {
      final data = response.data[paramData];

      // Handle list response
      if (fromJsonFunc != null && data is List) {
        final dataList = List<T>.from(
          data.map((item) => fromJsonFunc(item)).toList(),
        ) as K;
        return dataList;
      }

      // Handle single object response
      if (fromJsonFunc != null) {
        final model = fromJsonFunc(data) as K;
        return model;
      }

      // Return raw data
      return data as K;
    } else {
      // Business error
      final errorMsg = response.data[paramMsg];
      throw NetException(errorMsg, code);
    }
  }
}
