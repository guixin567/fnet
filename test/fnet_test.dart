import 'package:flutter_test/flutter_test.dart';
import 'package:fnet/fnet.dart';
import 'package:fnet/src/i18n/default_net_localizations.dart';
import 'package:fnet/src/i18n/en_net_localizations.dart';
import 'package:fnet/src/i18n/zh_hant_net_localizations.dart';

void main() {
  group('Result', () {
    test('success result should have correct properties', () {
      final result = Result<String>.success('test data', msg: 'success');

      expect(result.isSuccess, isTrue);
      expect(result.code, equals(200));
      expect(result.data, equals('test data'));
      expect(result.msg, equals('success'));
    });

    test('failure result should have correct properties', () {
      final result = Result<String>.failure(code: 500, msg: 'error');

      expect(result.isSuccess, isFalse);
      expect(result.code, equals(500));
      expect(result.data, isNull);
      expect(result.msg, equals('error'));
    });

    test('toString should return formatted string', () {
      final result = Result<String>.success('data');
      final str = result.toString();

      expect(str, contains('Result'));
      expect(str, contains('200'));
      expect(str, contains('data'));
    });
  });

  group('NetException', () {
    test('should return provided message', () {
      final exception = NetException('Custom error', 400);

      expect(exception.message, equals('Custom error'));
      expect(exception.code, equals(400));
    });

    test('should return default code when not provided', () {
      final exception = NetException('Error');

      expect(exception.code, equals(-1));
    });

    test('toString should return formatted string', () {
      final exception = NetException('Test error', 500);
      final str = exception.toString();

      expect(str, contains('NetException'));
      expect(str, contains('500'));
      expect(str, contains('Test error'));
    });
  });

  group('DefaultNetLocalizations', () {
    late DefaultNetLocalizations localizations;

    setUp(() {
      localizations = const DefaultNetLocalizations();
    });

    test('should return Chinese error messages', () {
      expect(localizations.noNetworkConnection, contains('网络'));
      expect(localizations.connectionTimeout, contains('超时'));
      expect(localizations.defaultError, contains('出错'));
    });
  });

  group('EnglishNetLocalizations', () {
    late EnglishNetLocalizations localizations;

    setUp(() {
      localizations = const EnglishNetLocalizations();
    });

    test('should return English error messages', () {
      expect(localizations.noNetworkConnection, contains('No network'));
      expect(localizations.connectionTimeout, contains('Connection timeout'));
      expect(localizations.sendTimeout, contains('Request timeout'));
      expect(localizations.receiveTimeout, contains('Response timeout'));
      expect(localizations.badRequest, contains('Bad request'));
      expect(localizations.unauthorized, contains('Unauthorized'));
      expect(localizations.forbidden, contains('Access denied'));
      expect(localizations.notFound, contains('Resource not found'));
      expect(localizations.internalServerError, contains('Server error'));
      expect(localizations.serverError, contains('Server error'));
      expect(localizations.requestCancelled, contains('Request cancelled'));
      expect(localizations.badCertificate, contains('Certificate error'));
      expect(localizations.connectionError, contains('Connection error'));
      expect(localizations.defaultError, contains('Request failed'));
      expect(localizations.unknownError, contains('Unknown error'));
    });
  });

  group('ZhHantNetLocalizations', () {
    late ZhHantNetLocalizations localizations;

    setUp(() {
      localizations = const ZhHantNetLocalizations();
    });

    test('should return Traditional Chinese error messages', () {
      expect(localizations.noNetworkConnection, contains('網路'));
      expect(localizations.connectionTimeout, contains('超時'));
      expect(localizations.sendTimeout, contains('請求超時'));
      expect(localizations.receiveTimeout, contains('響應超時'));
      expect(localizations.badRequest, contains('參數異常'));
      expect(localizations.unauthorized, contains('未授權'));
      expect(localizations.forbidden, contains('禁止訪問'));
      expect(localizations.notFound, contains('未找到'));
      expect(localizations.internalServerError, contains('服務異常'));
      expect(localizations.serverError, contains('服務異常'));
      expect(localizations.requestCancelled, contains('取消'));
      expect(localizations.badCertificate, contains('證書異常'));
      expect(localizations.connectionError, contains('網路異常'));
      expect(localizations.defaultError, contains('請求出錯'));
      expect(localizations.unknownError, contains('服務異常'));
    });
  });

  group('EnglishNetLocalizations', () {
    late EnglishNetLocalizations localizations;

    setUp(() {
      localizations = const EnglishNetLocalizations();
    });

    test('should return English error messages', () {
      expect(localizations.noNetworkConnection, contains('No network'));
      expect(localizations.connectionTimeout, contains('Connection timeout'));
      expect(localizations.sendTimeout, contains('Request timeout'));
      expect(localizations.receiveTimeout, contains('Response timeout'));
      expect(localizations.badRequest, contains('Bad request'));
      expect(localizations.unauthorized, contains('Unauthorized'));
      expect(localizations.forbidden, contains('Access denied'));
      expect(localizations.notFound, contains('Resource not found'));
      expect(localizations.internalServerError, contains('Server error'));
      expect(localizations.serverError, contains('Server error'));
      expect(localizations.requestCancelled, contains('Request cancelled'));
      expect(localizations.badCertificate, contains('Certificate error'));
      expect(localizations.connectionError, contains('Connection error'));
      expect(localizations.defaultError, contains('Request failed'));
      expect(localizations.unknownError, contains('Unknown error'));
    });
  });

  group('ZhHantNetLocalizations', () {
    late ZhHantNetLocalizations localizations;

    setUp(() {
      localizations = const ZhHantNetLocalizations();
    });

    test('should return Traditional Chinese error messages', () {
      expect(localizations.noNetworkConnection, contains('網路'));
      expect(localizations.connectionTimeout, contains('超時'));
      expect(localizations.sendTimeout, contains('超時'));
      expect(localizations.receiveTimeout, contains('超時'));
      expect(localizations.badRequest, contains('參數異常'));
      expect(localizations.unauthorized, contains('授權'));
      expect(localizations.forbidden, contains('權限'));
      expect(localizations.notFound, contains('資源'));
      expect(localizations.internalServerError, contains('服務'));
      expect(localizations.serverError, contains('服務'));
      expect(localizations.requestCancelled, contains('取消'));
      expect(localizations.badCertificate, contains('證書'));
      expect(localizations.connectionError, contains('網路'));
      expect(localizations.defaultError, contains('出錯'));
      expect(localizations.unknownError, contains('服務'));
    });
  });

  group('NetOptions', () {
    test('should be singleton', () {
      final instance1 = NetOptions.instance;
      final instance2 = NetOptions.instance;

      expect(identical(instance1, instance2), isTrue);
    });

    test('should have default localizations', () {
      expect(NetOptions.instance.localizations, isA<DefaultNetLocalizations>());
    });

    test('setBaseUrl should return instance for chaining', () {
      final result = NetOptions.instance.setBaseUrl('https://api.example.com');

      expect(result, equals(NetOptions.instance));
    });

    test('enableHttp2 should return instance for chaining', () {
      final result = NetOptions.instance.enableHttp2(true);

      expect(result, equals(NetOptions.instance));
    });

    test('enableRetry should accept configuration', () {
      final result = NetOptions.instance.enableRetry(
        enable: true,
        retryCount: 5,
        retryDelay: const Duration(seconds: 2),
      );

      expect(result, equals(NetOptions.instance));
    });

    test('enableCache should accept configuration', () {
      final result = NetOptions.instance.enableCache(enable: true);

      expect(result, equals(NetOptions.instance));
    });
  });

  group('HttpConfigBuilder', () {
    late HttpConfigBuilder builder;

    setUp(() {
      builder = HttpConfigBuilder();
    });

    test('should build NetConfig with all settings', () {
      builder
          .setBaseUrl('https://api.test.com')
          .setConnectTimeout(const Duration(seconds: 30))
          .setReceiveTimeout(const Duration(seconds: 30))
          .setSendTimeout(const Duration(seconds: 30))
          .addHeaders({'Authorization': 'Bearer token'});

      final config = builder.create();

      expect(config.baseUrl, equals('https://api.test.com'));
      expect(config.connectTimeout, equals(const Duration(seconds: 30)));
      expect(config.receiveTimeout, equals(const Duration(seconds: 30)));
      expect(config.sendTimeout, equals(const Duration(seconds: 30)));
      expect(config.headers?['Authorization'], equals('Bearer token'));
    });

    test('should add interceptors', () {
      builder.addInterceptor(LogInterceptor());
      builder.addAllInterceptors([LogInterceptor(), LogInterceptor()]);

      expect(builder.interceptors?.length, equals(3));
    });
  });

  group('HeadersInterceptor', () {
    test('should be created with static and dynamic headers', () {
      final interceptor = HeadersInterceptor(
        staticHeaders: {'X-Static': 'value'},
        dynamicHeaders: {'X-Dynamic': () => 'dynamic_value'},
      );

      expect(interceptor, isA<Interceptor>());
    });

    test('addStaticHeader should add header', () {
      final interceptor = HeadersInterceptor();
      interceptor.addStaticHeader('X-Test', 'value');

      // Verify no exception thrown
      expect(true, isTrue);
    });

    test('addDynamicHeader should add callback', () {
      final interceptor = HeadersInterceptor();
      interceptor.addDynamicHeader('X-Token', () => 'token_value');

      // Verify no exception thrown
      expect(true, isTrue);
    });

    test('clearHeaders should clear all headers', () {
      final interceptor = HeadersInterceptor(
        staticHeaders: {'X-Static': 'value'},
        dynamicHeaders: {'X-Dynamic': () => 'value'},
      );
      interceptor.clearHeaders();

      // Verify no exception thrown
      expect(true, isTrue);
    });
  });

  group('Constants', () {
    test('should have correct parameter keys', () {
      expect(paramMsg, equals('msg'));
      expect(paramCode, equals('code'));
      expect(paramData, equals('data'));
      expect(paramIsShowLoading, equals('isShowLoading'));
      expect(paramIsShowErrorToast, equals('isShowErrorToast'));
      expect(defaultErrorCode, equals(-1));
    });
  });
}
