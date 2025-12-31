import 'package:fnet/fnet.dart';

/// Loading interceptor.
/// Shows loading indicator when request starts and dismisses when complete.
/// Controlled by [paramIsShowLoading] parameter in request options.
class LoadingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if loading should be shown
    bool isLoading = options.extra[paramIsShowLoading] == true;
    if (isLoading) {
      NetOptions.instance.httpConfigBuilder?.showLoadingFunc?.call();
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check if loading should be dismissed
    bool isLoading = response.requestOptions.extra[paramIsShowLoading] == true;
    if (isLoading) {
      NetOptions.instance.httpConfigBuilder?.dismissLoadingFunc?.call();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check if loading should be dismissed on error
    bool isLoading = err.requestOptions.extra[paramIsShowLoading] == true;
    if (isLoading) {
      NetOptions.instance.httpConfigBuilder?.dismissLoadingFunc?.call();
    }
    handler.next(err);
  }
}