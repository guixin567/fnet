import 'package:flutter/foundation.dart';
import 'package:fnet/fnet.dart';
import 'package:fnet/src/typedefs.dart' show NetConverter;

/// Handy method to make http GET request, which is a alias of  [dio.fetch(RequestOptions)].
/// fromJsonFunc 为空返回原始数据
Future<Result<K>> get<T, K>(
  String path, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onReceiveProgress,
  NetDecoder? httpDecode,
  NetConverter<K>? converter,
  T? Function(dynamic)? fromJsonFunc,
      bool isShowLoading = false,
      bool isShowErrorToast = true,
}) async {
  assert(!(httpDecode != null && converter != null),
      'httpDecode和converter不能同时赋值，请删除一个');
  return await _execute(
    path,
    'GET',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onReceiveProgress: onReceiveProgress,
    httpDecode: httpDecode,
    converter: converter,
    fromJsonFunc: fromJsonFunc,
    isShowLoading: isShowLoading,
    isShowErrorToast: isShowErrorToast,
  );
}

/// Handy method to make http POST request, which is a alias of  [dio.fetch(RequestOptions)].
/// fromJsonFunc 为空返回原始数据
Future<Result<K>> post<T, K>(
  String path, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
  NetDecoder? httpDecode,
  NetConverter<K>? converter,
  T? Function(dynamic)? fromJsonFunc,
      bool isShowLoading = false,
      bool isShowErrorToast = false,
}) async {
  assert(!(httpDecode != null && converter != null),
      'httpDecode和converter不能同时赋值，请删除一个');
  return await _execute(
    path,
    'POST',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
    httpDecode: httpDecode,
    converter: converter,
    fromJsonFunc: fromJsonFunc,
    isShowLoading: isShowLoading,
    isShowErrorToast: isShowErrorToast,
  );
}

/// Handy method to make http PUT request, which is a alias of  [dio.fetch(RequestOptions)].
/// fromJsonFunc 为空返回原始数据
Future<Result<K>> put<T, K>(
  String path, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
  NetDecoder? httpDecode,
  NetConverter<K>? converter,
  T? Function(dynamic)? fromJsonFunc,
      bool isShowLoading = false,
      bool isShowErrorToast = false,
}) async {
  assert(!(httpDecode != null && converter != null),
      'httpDecode和converter不能同时赋值，请删除一个');
  return await _execute(
    path,
    'PUT',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
    httpDecode: httpDecode,
    converter: converter,
    fromJsonFunc: fromJsonFunc,
    isShowLoading: isShowLoading,
    isShowErrorToast: isShowErrorToast,
  );
}

/// Handy method to make http HEAD request, which is a alias of [dio.fetch(RequestOptions)].
/// fromJsonFunc 为空返回原始数据
Future<Result<K>> head<T, K>(
  String path, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  NetDecoder? httpDecode,
  NetConverter<K>? converter,
  T? Function(dynamic)? fromJsonFunc,
      bool isShowLoading = false,
      bool isShowErrorToast = false,
}) async {
  assert(!(httpDecode != null && converter != null),
      'httpDecode和converter不能同时赋值，请删除一个');
  return await _execute(
    path,
    'HEAD',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    httpDecode: httpDecode,
    converter: converter,
    fromJsonFunc: fromJsonFunc,
    isShowLoading: isShowLoading,
    isShowErrorToast: isShowErrorToast,
  );
}

/// Handy method to make http DELETE request, which is a alias of  [dio.fetch(RequestOptions)].
/// fromJsonFunc 为空返回原始数据
Future<Result<K>> delete<T, K>(
  String path, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  NetDecoder? httpDecode,
  NetConverter<K>? converter,
  T? Function(dynamic)? fromJsonFunc,
      bool isShowLoading = false,
      bool isShowErrorToast = false,
}) async {
  assert(!(httpDecode != null && converter != null),
      'httpDecode和converter不能同时赋值，请删除一个');
  return await _execute(
    path,
    'DELETE',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    httpDecode: httpDecode,
    converter: converter,
    fromJsonFunc: fromJsonFunc,
    isShowLoading: isShowLoading,
    isShowErrorToast: isShowErrorToast,
  );
}

/// Handy method to make http PATCH request, which is a alias of  [dio.fetch(RequestOptions)].
/// fromJsonFunc 为空返回原始数据
Future<Result<K>> patch<T, K>(
  String path, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
  NetDecoder? httpDecode,
  NetConverter<K>? converter,
  T? Function(dynamic)? fromJsonFunc,
      bool isShowLoading = false,
      bool isShowErrorToast = false,

}) async {
  assert(!(httpDecode != null && converter != null),
      'httpDecode和converter不能同时赋值，请删除一个');
  return await _execute(
    path,
    'PATCH',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
    httpDecode: httpDecode,
    converter: converter,
    fromJsonFunc: fromJsonFunc,
    isShowLoading: isShowLoading,
    isShowErrorToast: isShowErrorToast,
  );
}


Future<Response> download(
  String urlPath,
  dynamic savePath, {
  ProgressCallback? onReceiveProgress,
  Map<String, dynamic>? queryParameters,
  CancelToken? cancelToken,
  bool deleteOnError = true,
  String lengthHeader = Headers.contentLengthHeader,
  Object? data,
  Options? options,
}) async {
  return await NetOptions.instance.dio.download(
    urlPath,
    savePath,
    onReceiveProgress: onReceiveProgress,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
    deleteOnError: deleteOnError,
    lengthHeader: lengthHeader,
    data: data,
    options: options,
  );
}

/// This method invokes the [cancel()] method on either the input
/// [cancelToken] or internal [_cancelToken] to pre-maturely end all
/// requests attached to this token.
void cancelRequests({CancelToken? cancelToken}) {
  cancelToken?.cancel();
}

/// A method to make http request, which is a alias of  [dio.fetch(RequestOptions)].
Future<Result<K>> _execute<T, K>(
  String path,
  String method, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
  NetDecoder? httpDecode,
  NetConverter<K>? converter,
  T? Function(dynamic)? fromJsonFunc,
  bool isShowLoading = false,
  bool isShowErrorToast = false,
}) async {

  try {
    final response = await NetOptions.instance.dio.request(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options,isShowLoading,isShowErrorToast),
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    if (converter != null) {
      return await compute(converter, response);
    } else {
      var decode = await compute(
          _mapCompute<T, K>,
          _MapBean<T>(response, fromJsonFunc,
              httpDecode ?? NetOptions.instance.httpDecoder));
      return Result.success(decode);
    }
  } on DioException catch (e) {
    if (kDebugMode) print("$path => DioError${e.message}");
    ///增加业务message获取
    String? errorMessage = e.message;
    if(e.response?.data['message']?.toString().isNotEmpty ?? false){
      errorMessage = e.response?.data['message'];
    }

    return Result.failure(
        msg: errorMessage, code: e.response?.statusCode ?? defaultErrorCode);
  } on NetException catch (e) {
    if (kDebugMode) print("$path => NetException${e.toString()}");
    return Result.failure(msg: e.message, code: e.code);
  } on TypeError catch (e) {
    if (kDebugMode) print("$path => TypeError${e.toString()}");
    return Result.failure(msg: e.toString());
  }
}

Options _checkOptions(String method, Options? options, bool isShowLoading, bool isShowErrorToast) {
  options ??= Options();
  options.extra ??= {};
  options.extra?[paramIsShowLoading] = isShowLoading;
  options.extra?[paramIsShowErrorToast] = isShowErrorToast;
  options.method = method;
  return options;
}

/// A method to decode the response. use isolate
K _mapCompute<T, K>(_MapBean<T> bean) {
  return bean.httpDecode
      .decode(response: bean.response, fromJsonFunc: bean.fromJsonFunc);
}

/// `_MapBean` is a class that is used to pass parameters to the isolate.
class _MapBean<T> {
  final Response<dynamic> response;
  final T? Function(dynamic)? fromJsonFunc;
  final NetDecoder httpDecode;

  _MapBean(this.response, this.fromJsonFunc, this.httpDecode);
}
