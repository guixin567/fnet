import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fnet/src/typedefs.dart' show ToastCallback;

/// Dio configuration options.
class NetConfig {
  /// Request base url, it can contain sub paths like: https://pub.dev/api/.
  String? baseUrl;

  /// [HttpAdapter] is a bridge between [Dio] and [HttpClient].
  ///
  /// [Dio] implements standard and friendly API for developer.
  /// [HttpClient] is the real object that makes Http requests.
  ///
  /// We can use any [HttpClient]s not just "dart:io:HttpClient" to
  /// make the HTTP request. All we need is to provide a [HttpClientAdapter].
  ///
  /// If you want to customize the [HttpClientAdapter] you should instead use
  /// either [IOHttpClientAdapter] on `dart:io` platforms
  /// or [BrowserHttpClientAdapter] on `dart:html` platforms.
  ///
  /// ```dart
  /// dio.httpClientAdapter = HttpClientAdapter();
  /// ```
  HttpClientAdapter? httpClientAdapter;

  /// Each Dio instance has an interceptor by which you can intercept requests
  /// or responses before they are handled by `then` or `catchError`.
  /// The [interceptor] field contains a [RequestInterceptor]
  /// and a [ResponseInterceptor] instance.
  List<Interceptor>? interceptors;

  /// Timeout in milliseconds for opening url.
  Duration? connectTimeout;

  /// Timeout in milliseconds for sending data.
  Duration? sendTimeout;

  /// Timeout in milliseconds for receiving data.
  ///
  /// Note: [receiveTimeout] represents a timeout during data transfer!
  /// That is to say the client has connected to the server,
  /// and the server starts to send data to the client.
  ///
  /// `null` meanings no timeout limit.
  Duration? receiveTimeout;

  /// Http request headers. The keys of initial headers will be converted
  /// to lowercase, for example 'Content-Type' will be converted to 'content-type'.
  ///
  /// The key of Header Map is case-insensitive, eg: content-type and Content-Type
  /// are regard as the same key.
  Map<String, dynamic>? headers;

  NetConfig._internal(
    this.baseUrl,
    this.httpClientAdapter,
    this.interceptors,
    this.connectTimeout,
    this.sendTimeout,
    this.receiveTimeout,
    this.headers,
  );

  NetConfig.build(HttpConfigBuilder build)
      : this._internal(
          build.baseUrl,
          build.httpClientAdapter,
          build.interceptors,
          build.connectTimeout,
          build.sendTimeout,
          build.receiveTimeout,
          build.headers,
        );
}

/// Builder class for [NetConfig].
/// Uses builder pattern for fluent configuration.
class HttpConfigBuilder {
  String? _baseUrl;
  HttpClientAdapter? _httpClientAdapter;
  List<Interceptor>? _interceptors;
  Duration? _connectTimeout;
  Duration? _sendTimeout;
  Duration? _receiveTimeout;
  VoidCallback? _showLoadingFunc;
  VoidCallback? _dismissLoadingFunc;
  ToastCallback? _toastFunc;
  Map<String, dynamic>? _headers;

  /// Set base url for requests.
  HttpConfigBuilder setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    return this;
  }

  /// Set connection timeout.
  HttpConfigBuilder setConnectTimeout(Duration connectTimeout) {
    _connectTimeout = connectTimeout;
    return this;
  }

  /// Set HTTP client adapter.
  HttpConfigBuilder setHttpClientAdapter(HttpClientAdapter httpClientAdapter) {
    _httpClientAdapter = httpClientAdapter;
    return this;
  }

  /// Add request headers.
  HttpConfigBuilder addHeaders(Map<String, dynamic> headers) {
    _headers = headers;
    return this;
  }

  /// Add a single interceptor.
  HttpConfigBuilder addInterceptor(Interceptor interceptors) {
    _interceptors ??= [];
    _interceptors!.add(interceptors);
    return this;
  }

  /// Add multiple interceptors.
  HttpConfigBuilder addAllInterceptors(List<Interceptor> interceptors) {
    _interceptors ??= [];
    _interceptors!.addAll(interceptors);
    return this;
  }

  /// Set receive timeout.
  HttpConfigBuilder setReceiveTimeout(Duration receiveTimeout) {
    _receiveTimeout = receiveTimeout;
    return this;
  }

  /// Set send timeout.
  HttpConfigBuilder setSendTimeout(Duration sendTimeout) {
    _sendTimeout = sendTimeout;
    return this;
  }

  /// Set show loading callback.
  HttpConfigBuilder setShowLoadingFunc(VoidCallback showLoadingFunc) {
    _showLoadingFunc = showLoadingFunc;
    return this;
  }

  /// Set dismiss loading callback.
  HttpConfigBuilder setDismissLoadingFunc(VoidCallback dismissLoadingFunc) {
    _dismissLoadingFunc = dismissLoadingFunc;
    return this;
  }

  /// Set toast callback for error messages.
  HttpConfigBuilder setShowToastFunc(ToastCallback toastFunc) {
    _toastFunc = toastFunc;
    return this;
  }

  /// Create the [NetConfig] instance.
  NetConfig create() {
    return NetConfig.build(this);
  }

  String? get baseUrl => _baseUrl;

  HttpClientAdapter? get httpClientAdapter => _httpClientAdapter;

  List<Interceptor>? get interceptors => _interceptors;

  Duration? get connectTimeout => _connectTimeout;

  Duration? get sendTimeout => _sendTimeout;

  Duration? get receiveTimeout => _receiveTimeout;

  VoidCallback? get showLoadingFunc => _showLoadingFunc;

  VoidCallback? get dismissLoadingFunc => _dismissLoadingFunc;

  ToastCallback? get toastFunc => _toastFunc;

  Map<String, dynamic>? get headers => _headers;
}
