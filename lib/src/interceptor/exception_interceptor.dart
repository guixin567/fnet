import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fnet/src/config/net_constant.dart';
import 'package:fnet/src/config/net_options.dart';

///网络异常拦截器
class ExceptionInterceptor extends Interceptor {

  bool _isConnected = false;

  ExceptionInterceptor() {
    _initNetworkStatus();

    Connectivity().onConnectivityChanged.listen((event){
      _isConnected = ConnectivityResult.none != event.first;
    });
  }

  Future<void> _initNetworkStatus() async {
    _isConnected = await _checkNetworkConnection();
  }

  Future<bool> _checkNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return ConnectivityResult.none != connectivityResult.first;
  }



  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async{
    //是否展示loading
    bool isShowToast = err.requestOptions.extra[paramIsShowErrorToast] == true;
    String? errorMsg = err.message;
    ///没有网络的时候 toast，但是这里有防抖，假如进入一个页面调用3个接口，一段时间内只能有一个提示
    if (!_isConnected) {
      errorMsg = '无网络连接，请检查您的网络设置';
      NetOptions.instance.httpConfigBuilder?.toastFunc?.call(errorMsg);
    }else{
      // 处理网络异常
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
          errorMsg = "连接超时，请检查网络连接。";
          break;
        case DioExceptionType.sendTimeout:
          errorMsg = "请求超时，请稍后重试";
          break;
        case DioExceptionType.receiveTimeout:
          errorMsg = "响应超时，请检查网络连接";
          break;
        case DioExceptionType.badResponse:
        // 处理状态码异常
        // 根据状态码进行更细致的处理
          switch (err.response?.statusCode) {
            case 400:
              errorMsg = "参数异常";
              break;
            case 401:
              errorMsg = "未授权，可能需要登录";
              break;
            case 403:
              errorMsg = "禁止访问，您没有权限";
              break;
            case 404:
              errorMsg = "未找到请求的资源";
              break;
            case 500:
              errorMsg = "服务异常，请稍后重试";
              break;
            default:
              errorMsg = "服务异常，请稍后重试";
          }
          break;
        case DioExceptionType.cancel:
          errorMsg = "请求被取消";
          break;

        case DioExceptionType.badCertificate:
          errorMsg = "证书异常";
          break;
        case DioExceptionType.connectionError:
          errorMsg = "本地网络异常";
          break;
        case DioExceptionType.unknown:
        // 处理无网络情况
          if (err.message?.contains("SocketException") == true) {
            errorMsg = "无网络连接，请检查您的网络设置";
          } else {
            errorMsg = "服务异常，请稍后重试";
          }
          break;

        }

      if (isShowToast) {
        NetOptions.instance.httpConfigBuilder?.toastFunc?.call(errorMsg ?? '');
      }
    }


    // 继续传递错误
    handler.next(err);
  }

}
