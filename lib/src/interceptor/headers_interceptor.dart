import 'package:dio/dio.dart';

/// Callback type for dynamic header values.
typedef DynamicHeaderCallback = String? Function();

/// Headers interceptor.
/// Adds dynamic headers to every request.
class HeadersInterceptor extends Interceptor {
  final Map<String, dynamic> _staticHeaders;
  final Map<String, DynamicHeaderCallback> _dynamicHeaders;

  /// Create a headers interceptor.
  ///
  /// [staticHeaders] - Headers with static values
  /// [dynamicHeaders] - Headers with callback functions for dynamic values
  HeadersInterceptor({
    Map<String, dynamic>? staticHeaders,
    Map<String, DynamicHeaderCallback>? dynamicHeaders,
  })  : _staticHeaders = staticHeaders ?? {},
        _dynamicHeaders = dynamicHeaders ?? {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add static headers
    options.headers.addAll(_staticHeaders);

    // Add dynamic headers
    for (final entry in _dynamicHeaders.entries) {
      final value = entry.value();
      if (value != null && value.isNotEmpty) {
        options.headers[entry.key] = value;
      }
    }

    handler.next(options);
  }

  /// Add a static header.
  void addStaticHeader(String key, dynamic value) {
    _staticHeaders[key] = value;
  }

  /// Add a dynamic header with a callback.
  void addDynamicHeader(String key, DynamicHeaderCallback callback) {
    _dynamicHeaders[key] = callback;
  }

  /// Remove a header by key.
  void removeHeader(String key) {
    _staticHeaders.remove(key);
    _dynamicHeaders.remove(key);
  }

  /// Clear all headers.
  void clearHeaders() {
    _staticHeaders.clear();
    _dynamicHeaders.clear();
  }
}