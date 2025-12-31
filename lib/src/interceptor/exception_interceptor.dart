import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fnet/src/config/net_constant.dart';
import 'package:fnet/src/config/net_options.dart';

/// Network exception interceptor.
/// Handles network errors and displays appropriate toast messages.
class ExceptionInterceptor extends Interceptor {
  bool _isConnected = false;

  ExceptionInterceptor() {
    _initNetworkStatus();

    Connectivity().onConnectivityChanged.listen((event) {
      _isConnected = !event.contains(ConnectivityResult.none);
    });
  }

  Future<void> _initNetworkStatus() async {
    _isConnected = await _checkNetworkConnection();
  }

  Future<bool> _checkNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error toast should be shown
    bool isShowToast = err.requestOptions.extra[paramIsShowErrorToast] == true;
    final localizations = NetOptions.instance.localizations;
    String errorMsg = err.message ?? '';

    // Handle no network connection
    if (!_isConnected) {
      errorMsg = localizations.noNetworkConnection;
      NetOptions.instance.httpConfigBuilder?.toastFunc?.call(errorMsg);
    } else {
      // Handle network errors based on type
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
          errorMsg = localizations.connectionTimeout;
          break;
        case DioExceptionType.sendTimeout:
          errorMsg = localizations.sendTimeout;
          break;
        case DioExceptionType.receiveTimeout:
          errorMsg = localizations.receiveTimeout;
          break;
        case DioExceptionType.badResponse:
          // Handle status code errors
          switch (err.response?.statusCode) {
            case 400:
              errorMsg = localizations.badRequest;
              break;
            case 401:
              errorMsg = localizations.unauthorized;
              break;
            case 403:
              errorMsg = localizations.forbidden;
              break;
            case 404:
              errorMsg = localizations.notFound;
              break;
            case 500:
              errorMsg = localizations.internalServerError;
              break;
            default:
              errorMsg = localizations.serverError;
          }
          break;
        case DioExceptionType.cancel:
          errorMsg = localizations.requestCancelled;
          break;
        case DioExceptionType.badCertificate:
          errorMsg = localizations.badCertificate;
          break;
        case DioExceptionType.connectionError:
          errorMsg = localizations.connectionError;
          break;
        case DioExceptionType.unknown:
          // Handle no network situation
          if (err.message?.contains("SocketException") == true) {
            errorMsg = localizations.noNetworkConnection;
          } else {
            errorMsg = localizations.unknownError;
          }
          break;
      }

      // Try to extract error message from response data (type-safe)
      final responseData = err.response?.data;
      if (responseData is Map &&
          responseData['message']?.toString().isNotEmpty == true) {
        errorMsg = responseData['message'].toString();
      }

      if (isShowToast) {
        NetOptions.instance.httpConfigBuilder?.toastFunc?.call(errorMsg);
      }
    }

    // Continue passing the error
    handler.next(err);
  }
}
