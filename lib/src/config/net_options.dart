import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:fnet/src/decoder/default_net_decoder.dart' show DefaultNetDecoder;
import 'package:fnet/src/decoder/net_decoder.dart';
import 'package:fnet/src/i18n/default_net_localizations.dart';
import 'package:fnet/src/i18n/net_localizations.dart';
import 'package:fnet/src/typedefs.dart' show ToastCallback;
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'net_config.dart';

/// Network options configuration with builder pattern.
/// Provides centralized configuration for dio-based HTTP client.
class NetOptions {
  /// Private constructor
  NetOptions._() : _httpConfigBuilder = HttpConfigBuilder();

  /// The one and only instance of this singleton
  static final instance = NetOptions._();

  final HttpConfigBuilder _httpConfigBuilder;

  final Dio _dio = Dio();

  Dio get dio => _dio;

  NetDecoder _httpDecoder = DefaultNetDecoder.getInstance() as NetDecoder;

  /// Localization instance for error messages
  NetLocalizations _localizations = const DefaultNetLocalizations();

  HttpConfigBuilder? get httpConfigBuilder => _httpConfigBuilder;

  NetDecoder get httpDecoder => _httpDecoder;

  /// Get current localizations
  NetLocalizations get localizations => _localizations;

  bool _isLogger = true;
  bool _enableHttp2 = false;
  bool _enableRetry = false;
  bool _enableCache = false;

  /// Retry configuration
  int _retryCount = 3;
  Duration _retryDelay = const Duration(seconds: 1);

  /// Cache configuration
  CacheOptions? _cacheOptions;

  /// Setting the base url for the http request.
  NetOptions setBaseUrl(String baseUrl) {
    _httpConfigBuilder.setBaseUrl(baseUrl);
    return instance;
  }

  /// Setting the connection timeout for the http request.
  NetOptions setConnectTimeout(Duration connectTimeout) {
    _httpConfigBuilder.setConnectTimeout(connectTimeout);
    return instance;
  }

  /// Adding headers to the request.
  NetOptions addHeaders(Map<String, dynamic> headers) {
    _httpConfigBuilder.addHeaders(headers);
    return instance;
  }

  /// Setting the httpClientAdapter for the http request.
  /// Example: proxy, certificate
  NetOptions setHttpClientAdapter(HttpClientAdapter httpClientAdapter) {
    _httpConfigBuilder.setHttpClientAdapter(httpClientAdapter);
    return instance;
  }

  /// Adding an interceptor to the dio instance.
  NetOptions addInterceptor(Interceptor interceptor) {
    _httpConfigBuilder.addInterceptor(interceptor);
    return instance;
  }

  /// Adding all the interceptors to the dio instance.
  NetOptions addAllInterceptors(List<Interceptor> interceptors) {
    _httpConfigBuilder.addAllInterceptors(interceptors);
    return instance;
  }

  /// Setting the timeout for receiving data.
  NetOptions setReceiveTimeout(Duration receiveTimeout) {
    _httpConfigBuilder.setReceiveTimeout(receiveTimeout);
    return instance;
  }

  /// Setting the timeout for sending data.
  NetOptions setSendTimeout(Duration sendTimeout) {
    _httpConfigBuilder.setSendTimeout(sendTimeout);
    return instance;
  }

  /// Used to set the decoder for the response.
  NetOptions setHttpDecoder(NetDecoder httpDecoder) {
    _httpDecoder = httpDecoder;
    return instance;
  }

  /// Set the show loading callback function.
  NetOptions setShowLoadingFunc(VoidCallback showLoadingFunc) {
    _httpConfigBuilder.setShowLoadingFunc(showLoadingFunc);
    return instance;
  }

  /// Set the dismiss loading callback function.
  NetOptions setDismissLoadingFunc(VoidCallback dismissLoadingFunc) {
    _httpConfigBuilder.setDismissLoadingFunc(dismissLoadingFunc);
    return instance;
  }

  /// Set the toast callback function for error messages.
  NetOptions setShowToastFunc(ToastCallback toastFunc) {
    _httpConfigBuilder.setShowToastFunc(toastFunc);
    return instance;
  }

  /// Set custom localizations for error messages (i18n support).
  /// Users can implement [NetLocalizations] to provide translations.
  NetOptions setLocalizations(NetLocalizations localizations) {
    _localizations = localizations;
    return instance;
  }

  /// Used to enable/disable the logger.
  /// Default uses PrettyDioLogger for printing.
  NetOptions enableLogger(bool enable) {
    _isLogger = enable;
    return instance;
  }

  /// Enable HTTP/2 support using native_dio_adapter.
  /// HTTP/2 provides improved performance with multiplexing,
  /// header compression, and server push.
  NetOptions enableHttp2(bool enable) {
    _enableHttp2 = enable;
    return instance;
  }

  /// Enable automatic request retry on failure.
  /// [retryCount] - Number of retry attempts (default: 3)
  /// [retryDelay] - Delay between retries (default: 1 second)
  NetOptions enableRetry({
    bool enable = true,
    int retryCount = 3,
    Duration retryDelay = const Duration(seconds: 1),
  }) {
    _enableRetry = enable;
    _retryCount = retryCount;
    _retryDelay = retryDelay;
    return instance;
  }

  /// Enable response caching.
  /// [cacheOptions] - Custom cache options (optional)
  NetOptions enableCache({
    bool enable = true,
    CacheOptions? cacheOptions,
  }) {
    _enableCache = enable;
    _cacheOptions = cacheOptions;
    return instance;
  }

  /// Configure network request and initialize.
  void create() {
    var httpConfig = _httpConfigBuilder.create();

    // Enable HTTP/2 if configured
    if (_enableHttp2) {
      _dio.httpClientAdapter = NativeAdapter();
    } else if (httpConfig.httpClientAdapter != null) {
      _dio.httpClientAdapter = httpConfig.httpClientAdapter!;
    }

    // Add cache interceptor if enabled
    if (_enableCache) {
      final cacheOpts = _cacheOptions ??
          CacheOptions(
            store: MemCacheStore(),
            policy: CachePolicy.request,
            hitCacheOnErrorExcept: [401, 403],
            maxStale: const Duration(days: 7),
          );
      _dio.interceptors.add(DioCacheInterceptor(options: cacheOpts));
    }

    // Add custom interceptors
    if (httpConfig.interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(httpConfig.interceptors!);
    }

    // Add retry interceptor if enabled
    if (_enableRetry) {
      _dio.interceptors.add(
        RetryInterceptor(
          dio: _dio,
          retries: _retryCount,
          retryDelays: List.generate(
            _retryCount,
            (index) => _retryDelay * (index + 1),
          ),
        ),
      );
    }

    // Add logger interceptor if enabled
    if (_isLogger) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }

    _dio.options = BaseOptions(
      baseUrl: httpConfig.baseUrl ?? '',
      contentType: 'application/json',
      connectTimeout: httpConfig.connectTimeout,
      sendTimeout: httpConfig.sendTimeout,
      receiveTimeout: httpConfig.receiveTimeout,
      headers: httpConfig.headers,
    );
  }
}
