import 'package:dio/dio.dart';
import 'package:fnet/src/config/net_constant.dart';
import 'package:fnet/src/config/net_options.dart';

/// Loading interceptor.
/// Shows loading indicator when request starts and dismisses when complete.
/// Controlled by [paramIsShowLoading] parameter in request options.
/// Uses a counter to handle concurrent requests correctly.
class LoadingInterceptor extends Interceptor {
  int _requestCount = 0;
  final NetOptions? _options;

  /// Create a loading interceptor.
  /// [_options] - Optional NetOptions to use for callbacks. If null, uses the options from request.
  LoadingInterceptor({NetOptions? options}) : _options = options;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if loading should be shown
    bool isLoading = options.extra[paramIsShowLoading] == true;
    if (isLoading) {
      _requestCount++;
      if (_requestCount == 1) {
        _getOptions(options).httpConfigBuilder?.showLoadingFunc?.call();
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _dismissLoading(response.requestOptions);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _dismissLoading(err.requestOptions);
    handler.next(err);
  }

  void _dismissLoading(RequestOptions options) {
    // Check if loading should be dismissed
    bool isLoading = options.extra[paramIsShowLoading] == true;
    if (isLoading) {
      if (_requestCount > 0) {
        _requestCount--;
      }
      if (_requestCount == 0) {
        _getOptions(options).httpConfigBuilder?.dismissLoadingFunc?.call();
      }
    }
  }

  NetOptions _getOptions(RequestOptions options) {
    if (_options != null) return _options!;
    return NetOptions.instance;
  }
}