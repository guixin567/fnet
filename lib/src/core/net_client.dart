import '../utils/net_runner.dart';
import 'package:dio/dio.dart';
import 'package:fnet/src/config/net_constant.dart';
import 'package:fnet/src/config/net_options.dart';
import 'package:fnet/src/decoder/net_decoder.dart';
import 'package:fnet/src/entity/result.dart';
import 'package:fnet/src/net_exception.dart';
import 'package:fnet/src/typedefs.dart' show NetConverter;

/// Threshold for using isolate (100KB).
/// Data larger than this will be processed in isolate.
const int _isolateThreshold = 100 * 1024;

/// A network client that wraps Dio and provides high-level API methods.
class NetClient {
  final NetOptions options;

  /// Create a new [NetClient] with the given [options].
  /// If [options] is not provided, [NetOptions.instance] is used.
  NetClient({NetOptions? options}) : options = options ?? NetOptions.instance;

  /// Default client instance for backward compatibility.
  static final NetClient _defaultClient = NetClient(options: NetOptions.instance);

  /// Handy method to make HTTP GET request.
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
    return await execute(
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

  /// Handy method to make HTTP POST request.
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
    return await execute(
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

  /// Handy method to make HTTP PUT request.
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
    return await execute(
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

  /// Handy method to make HTTP HEAD request.
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
    return await execute(
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

  /// Handy method to make HTTP DELETE request.
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
    return await execute(
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

  /// Handy method to make HTTP PATCH request.
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
    return await execute(
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

  /// Download file from url.
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
    return await this.options.dio.download(
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

  /// Internal method to execute HTTP requests.
  Future<Result<K>> execute<T, K>(
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
    assert(!(httpDecode != null && converter != null),
        'httpDecode and converter cannot be used simultaneously');

    try {
      final response = await this.options.dio.request(
            path,
            data: data,
            queryParameters: queryParameters,
            options: _checkOptions(method, options, isShowLoading, isShowErrorToast),
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
          );

      if (converter != null) {
        // Use isolate for large data, otherwise process on main thread
        final responseSize = _estimateResponseSize(response);
        if (responseSize > _isolateThreshold) {
          return await NetRunner.run(converter, response);
        } else {
          return converter(response);
        }
      } else {
        final decoder = httpDecode ?? this.options.httpDecoder;
        final responseSize = _estimateResponseSize(response);

        // Use isolate for large data, otherwise process on main thread
        if (responseSize > _isolateThreshold) {
          var decode = await NetRunner.run(
            _mapCompute<T, K>,
            _MapBean<T>(response, fromJsonFunc, decoder),
          );
          return Result.success(decode, code: response.statusCode);
        } else {
          var decode = decoder.decode<T, K>(
            response: response,
            fromJsonFunc: fromJsonFunc,
          );
          return Result.success(decode, code: response.statusCode);
        }
      }
    } on DioException catch (e) {
        if (NetRunner.isDebug) print("$path => DioException: ${e.message}");

      // Extract error message with type-safe access
      String? errorMessage = e.message;
      final responseData = e.response?.data;
      if (responseData is Map &&
          responseData['message']?.toString().isNotEmpty == true) {
        errorMessage = responseData['message'].toString();
      }

      return Result.failure(
        msg: errorMessage,
        code: e.response?.statusCode ?? defaultErrorCode,
      );
    } on NetException catch (e) {
      if (NetRunner.isDebug) print("$path => NetException: ${e.toString()}");
      return Result.failure(msg: e.message, code: e.code);
    } on TypeError catch (e) {
      if (NetRunner.isDebug) print("$path => TypeError: ${e.toString()}");
      return Result.failure(msg: e.toString());
    }
  }
}

/// Handy method to make HTTP GET request using default client.
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
}) =>
    NetClient._defaultClient.get<T, K>(
      path,
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

/// Handy method to make HTTP POST request using default client.
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
}) =>
    NetClient._defaultClient.post<T, K>(
      path,
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

/// Handy method to make HTTP PUT request using default client.
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
}) =>
    NetClient._defaultClient.put<T, K>(
      path,
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

/// Handy method to make HTTP HEAD request using default client.
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
}) =>
    NetClient._defaultClient.head<T, K>(
      path,
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

/// Handy method to make HTTP DELETE request using default client.
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
}) =>
    NetClient._defaultClient.delete<T, K>(
      path,
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

/// Handy method to make HTTP PATCH request using default client.
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
}) =>
    NetClient._defaultClient.patch<T, K>(
      path,
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

/// Download file from url using default client.
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
}) =>
    NetClient._defaultClient.download(
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

/// Cancel all requests attached to the given [cancelToken].
void cancelRequests({CancelToken? cancelToken}) {
  cancelToken?.cancel();
}

/// Estimate response data size for deciding whether to use isolate.
int _estimateResponseSize(Response response) {
  final data = response.data;
  if (data == null) return 0;
  if (data is String) return data.length;
  if (data is List) return data.length * 100; // Rough estimate
  if (data is Map) return data.length * 200; // Rough estimate
  return 0;
}

/// Build request options with loading and toast flags.
Options _checkOptions(
  String method,
  Options? options,
  bool isShowLoading,
  bool isShowErrorToast,
) {
  options ??= Options();
  options.extra ??= {};
  options.extra?[paramIsShowLoading] = isShowLoading;
  options.extra?[paramIsShowErrorToast] = isShowErrorToast;
  options.method = method;
  return options;
}

/// Decode response in isolate.
K _mapCompute<T, K>(_MapBean<T> bean) {
  return bean.httpDecode.decode(response: bean.response, fromJsonFunc: bean.fromJsonFunc);
}

/// Bean class for passing parameters to isolate.
class _MapBean<T> {
  final Response<dynamic> response;
  final T? Function(dynamic)? fromJsonFunc;
  final NetDecoder httpDecode;

  _MapBean(this.response, this.fromJsonFunc, this.httpDecode);
}
