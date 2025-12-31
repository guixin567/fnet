# FNet

A powerful and easy-to-use Flutter network library based on Dio.

## Features

- ✅ **HTTP/2 Support** - Improved performance with multiplexing and header compression
- ✅ **Internationalization (i18n)** - Customizable error messages for any language
- ✅ **Automatic Retry** - Smart retry mechanism for failed requests
- ✅ **Response Caching** - Configurable cache strategy with memory/disk storage
- ✅ **Token Refresh** - Automatic 401 handling with token refresh and request retry
- ✅ **Loading Indicator** - Built-in loading state management
- ✅ **Error Handling** - Comprehensive network error handling with toast support
- ✅ **Request Logging** - Beautiful request/response logging with PrettyDioLogger

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  fnet:
    git:
      url: https://github.com/your-repo/fnet.git
```

## Quick Start

### Basic Configuration

```dart
import 'package:fnet/fnet.dart';

void main() {
  NetOptions.instance
    .setBaseUrl("https://api.example.com/")
    .setConnectTimeout(const Duration(seconds: 30))
    .setReceiveTimeout(const Duration(seconds: 30))
    .addHeaders({"Content-Type": "application/json"})
    .enableLogger(true)
    .create();
}
```

### Enable HTTP/2

```dart
NetOptions.instance
  .setBaseUrl("https://api.example.com/")
  .enableHttp2(true)  // Enable HTTP/2
  .create();
```

### Enable Retry

```dart
NetOptions.instance
  .setBaseUrl("https://api.example.com/")
  .enableRetry(
    enable: true,
    retryCount: 3,
    retryDelay: const Duration(seconds: 1),
  )
  .create();
```

### Enable Caching

```dart
NetOptions.instance
  .setBaseUrl("https://api.example.com/")
  .enableCache(
    enable: true,
    cacheOptions: CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
    ),
  )
  .create();
```

### Custom Localizations (i18n)

```dart
class EnglishLocalizations implements NetLocalizations {
  @override
  String get noNetworkConnection => 'No network connection';
  @override
  String get connectionTimeout => 'Connection timeout';
  // ... implement other methods
}

NetOptions.instance
  .setLocalizations(EnglishLocalizations())
  .create();
```

### Making Requests

```dart
// GET request
final result = await get<User, User>(
  'users/1',
  fromJsonFunc: User.fromJson,
  isShowLoading: true,
);

if (result.isSuccess) {
  print(result.data);
} else {
  print(result.msg);
}

// POST request
final result = await post<void, Map>(
  'users',
  data: {'name': 'John', 'email': 'john@example.com'},
);
```

### Token Refresh Interceptor

```dart
NetOptions.instance
  .addInterceptor(TokenRefreshInterceptor(
    dio: NetOptions.instance.dio,
    getToken: () => myTokenStorage.accessToken,
    onRefresh: () async {
      final newToken = await refreshTokenAPI();
      myTokenStorage.accessToken = newToken;
      return newToken;
    },
  ))
  .create();
```

### Dynamic Headers

```dart
NetOptions.instance
  .addInterceptor(HeadersInterceptor(
    staticHeaders: {'X-App-Version': '1.0.0'},
    dynamicHeaders: {
      'Authorization': () => 'Bearer ${getToken()}',
    },
  ))
  .create();
```

## API Reference

### NetOptions Methods

| Method | Description |
|--------|-------------|
| `setBaseUrl(String)` | Set the base URL for all requests |
| `setConnectTimeout(Duration)` | Set connection timeout |
| `setReceiveTimeout(Duration)` | Set receive timeout |
| `setSendTimeout(Duration)` | Set send timeout |
| `addHeaders(Map)` | Add default headers |
| `addInterceptor(Interceptor)` | Add a custom interceptor |
| `enableLogger(bool)` | Enable/disable request logging |
| `enableHttp2(bool)` | Enable/disable HTTP/2 |
| `enableRetry({...})` | Configure automatic retry |
| `enableCache({...})` | Configure response caching |
| `setLocalizations(NetLocalizations)` | Set custom error messages |
| `setShowLoadingFunc(VoidCallback)` | Set loading show callback |
| `setDismissLoadingFunc(VoidCallback)` | Set loading dismiss callback |
| `setShowToastFunc(ToastCallback)` | Set toast callback |
| `create()` | Build and apply configuration |

### Request Methods

- `get<T, K>(...)` - HTTP GET
- `post<T, K>(...)` - HTTP POST
- `put<T, K>(...)` - HTTP PUT
- `delete<T, K>(...)` - HTTP DELETE
- `patch<T, K>(...)` - HTTP PATCH
- `head<T, K>(...)` - HTTP HEAD
- `download(...)` - Download file

## Dependencies

- [dio](https://pub.dev/packages/dio) ^5.9.0
- [connectivity_plus](https://pub.dev/packages/connectivity_plus) ^7.0.0
- [native_dio_adapter](https://pub.dev/packages/native_dio_adapter) ^1.3.0
- [dio_smart_retry](https://pub.dev/packages/dio_smart_retry) ^7.0.1
- [dio_cache_interceptor](https://pub.dev/packages/dio_cache_interceptor) ^3.5.0
- [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger) ^1.4.0

## License

MIT License
