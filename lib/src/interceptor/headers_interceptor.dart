
import 'package:dio/dio.dart' show Interceptor, RequestInterceptorHandler, RequestOptions, Response, ResponseInterceptorHandler;

class HeadersInterceptor extends Interceptor{
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }
}