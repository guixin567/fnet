
import 'package:fnet/fnet.dart';

///是否展示loading的拦截器
///当请求参数中设置isLoading为true时，则展示loading，请求结束后关闭loading
class LoadingInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //是否展示loading
    bool isLoading = options.extra[paramIsShowLoading] == true;
    //掉用showLoading的方法
    if(isLoading){
      NetOptions.instance.httpConfigBuilder?.showLoadingFunc?.call();
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //是否展示loading
    bool isLoading = response.requestOptions.extra[paramIsShowLoading] == true;
    //掉用dismissLoading的方法
    if(isLoading){
      NetOptions.instance.httpConfigBuilder?.dismissLoadingFunc?.call();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //是否展示loading
    bool isLoading = err.requestOptions.extra[paramIsShowLoading] == true;
    //掉用dismissLoading的方法
    if(isLoading){
      NetOptions.instance.httpConfigBuilder?.dismissLoadingFunc?.call();
    }
    handler.next(err);
  }
}