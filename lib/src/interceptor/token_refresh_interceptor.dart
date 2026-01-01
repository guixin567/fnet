import 'dart:async';
import 'package:dio/dio.dart';

/// Token refresh callback function type.
/// Returns the new access token after refresh.
typedef TokenRefreshCallback = Future<String?> Function();

/// Get current access token callback.
typedef GetTokenCallback = String? Function();

/// Token refresh interceptor.
/// Automatically handles 401 responses by refreshing the token and retrying the request.
class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  final TokenRefreshCallback onRefresh;
  final GetTokenCallback getToken;
  final String headerKey;

  bool _isRefreshing = false;
  final List<_RequestRetry> _pendingRequests = [];

  /// Create a token refresh interceptor.
  ///
  /// [dio] - The Dio instance to use for retries
  /// [onRefresh] - Callback to refresh the token
  /// [getToken] - Callback to get the current token
  /// [headerKey] - Header key for authorization (default: 'Authorization')
  TokenRefreshInterceptor({
    required Dio dio,
    required this.onRefresh,
    required this.getToken,
    this.headerKey = 'Authorization',
  }) : _dio = dio;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add token to request if available
    final token = getToken();
    if (token != null && token.isNotEmpty) {
      options.headers[headerKey] = token;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      if (_isRefreshing) {
        // Already refreshing, queue this request
        _pendingRequests.add(_RequestRetry(
          options: err.requestOptions,
          handler: handler,
        ));
        return;
      }

      _isRefreshing = true;

      try {
        final newToken = await onRefresh();
        _isRefreshing = false;

        if (newToken != null && newToken.isNotEmpty) {
          // Retry the original request with new token
          err.requestOptions.headers[headerKey] = newToken;
          final response = await _dio.fetch(err.requestOptions);
          handler.resolve(response);

          // Retry all pending requests
          for (final retry in _pendingRequests) {
            retry.options.headers[headerKey] = newToken;
            try {
              final retryResponse = await _dio.fetch(retry.options);
              retry.handler.resolve(retryResponse);
            } catch (e) {
              retry.handler.reject(DioException(
                requestOptions: retry.options,
                error: e,
              ));
            }
          }
          _pendingRequests.clear();
          return;
        }
      } catch (e) {
        _isRefreshing = false;
        // Reject all pending requests
        for (final retry in _pendingRequests) {
          retry.handler.reject(DioException(
            requestOptions: retry.options,
            error: e,
          ));
        }
        _pendingRequests.clear();
      }
    }

    handler.next(err);
  }
}

/// Internal class to store pending request retry information.
class _RequestRetry {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RequestRetry({required this.options, required this.handler});
}
