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
    // If the backend doesn't follow the code/data/msg convention, 
    // we use the HTTP status code as the source of truth if the field is missing.
    final dynamic dataMap = response.data;
    final dynamic rawCode = (dataMap is Map) ? dataMap[paramCode] : response.statusCode;
    final int? code = int.tryParse(rawCode?.toString() ?? '') ?? (rawCode is int ? rawCode : response.statusCode);

    // Request successful (business success: 200-299)
    if (code != null && code >= 200 && code < 300) {
      final data = (dataMap is Map) ? dataMap[paramData] : dataMap;

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
