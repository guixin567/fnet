# FNet 使用指南

## 目录

1. [快速开始](#快速开始)
2. [基础配置](#基础配置)
3. [发起请求](#发起请求)
4. [高级功能](#高级功能)
5. [拦截器](#拦截器)
6. [国际化](#国际化)
7. [最佳实践](#最佳实践)

---

## 快速开始

### 安装依赖

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  fnet:
    path: ../fnet  # 本地路径
    # 或使用 git
    # git:
    #   url: https://github.com/your-repo/fnet.git
```

### 初始化网络配置

在应用启动时（如 `main.dart`）进行初始化：

```dart
import 'package:fnet/fnet.dart';

void main() {
  // 配置网络
  NetOptions.instance
    .setBaseUrl("https://api.example.com/")
    .setConnectTimeout(const Duration(seconds: 30))
    .setReceiveTimeout(const Duration(seconds: 30))
    .enableLogger(true)
    .create();

  runApp(MyApp());
}
```

---

## 基础配置

### 完整配置示例

```dart
NetOptions.instance
  // 基础 URL
  .setBaseUrl("https://api.example.com/")
  
  // 超时设置
  .setConnectTimeout(const Duration(seconds: 30))
  .setReceiveTimeout(const Duration(seconds: 30))
  .setSendTimeout(const Duration(seconds: 30))
  
  // 默认请求头
  .addHeaders({
    "Content-Type": "application/json",
    "Accept-Language": "zh-CN",
  })
  
  // Loading 和 Toast 回调
  .setShowLoadingFunc(() => showLoading())
  .setDismissLoadingFunc(() => dismissLoading())
  .setShowToastFunc((msg) => showToast(msg))
  
  // 功能开关
  .enableLogger(true)      // 开启日志
  .enableHttp2(true)       // 开启 HTTP/2
  .enableRetry(retryCount: 3)  // 开启重试
  .enableCache(enable: true)   // 开启缓存
  
  // 自定义拦截器
  .addInterceptor(ExceptionInterceptor())
  .addInterceptor(LoadingInterceptor())
  
  // 构建配置
  .create();
```

### 配置参数说明

| 方法 | 说明 | 默认值 |
|------|------|--------|
| `setBaseUrl` | 设置基础 URL | 无 |
| `setConnectTimeout` | 连接超时时间 | 无 |
| `setReceiveTimeout` | 接收超时时间 | 无 |
| `setSendTimeout` | 发送超时时间 | 无 |
| `addHeaders` | 添加默认请求头 | 无 |
| `enableLogger` | 开启/关闭日志打印 | true |
| `enableHttp2` | 开启/关闭 HTTP/2 | false |
| `enableRetry` | 开启请求重试 | false |
| `enableCache` | 开启响应缓存 | false |

---

## 发起请求

### GET 请求

```dart
// 简单请求
final result = await get<void, Map>('users');

// 带参数请求
final result = await get<void, Map>(
  'users',
  queryParameters: {'page': 1, 'size': 20},
);

// 带 Loading 和错误 Toast
final result = await get<void, Map>(
  'users/1',
  isShowLoading: true,
  isShowErrorToast: true,
);
```

### POST 请求

```dart
// 发送 JSON 数据
final result = await post<void, Map>(
  'users',
  data: {
    'name': 'John',
    'email': 'john@example.com',
  },
);

// 发送 FormData
final result = await post<void, Map>(
  'upload',
  data: FormData.fromMap({
    'file': await MultipartFile.fromFile('/path/to/file'),
  }),
);
```

### 其他请求方法

```dart
// PUT
await put<void, Map>('users/1', data: {'name': 'Updated'});

// DELETE
await delete<void, Map>('users/1');

// PATCH
await patch<void, Map>('users/1', data: {'status': 'active'});

// HEAD
await head<void, Map>('users/1');
```

### 下载文件

```dart
await download(
  'https://example.com/file.zip',
  '/path/to/save/file.zip',
  onReceiveProgress: (received, total) {
    final progress = received / total * 100;
    print('下载进度: $progress%');
  },
);
```

### 处理响应

```dart
final result = await get<User, User>(
  'users/1',
  fromJsonFunc: User.fromJson,
);

if (result.isSuccess) {
  // 成功处理
  final user = result.data!;
  print('用户名: ${user.name}');
} else {
  // 失败处理
  print('错误码: ${result.code}');
  print('错误信息: ${result.msg}');
}
```

### 请求列表数据

```dart
final result = await get<User, List<User>>(
  'users',
  fromJsonFunc: User.fromJson,  // 会自动映射为 List<User>
);

if (result.isSuccess) {
  final users = result.data!;
  for (final user in users) {
    print(user.name);
  }
}
```

---

## 高级功能

### HTTP/2 支持

HTTP/2 提供多路复用、头部压缩等性能优化：

```dart
NetOptions.instance
  .enableHttp2(true)
  .create();
```

### 请求重试

当请求失败时自动重试：

```dart
NetOptions.instance
  .enableRetry(
    enable: true,
    retryCount: 3,                          // 最多重试 3 次
    retryDelay: const Duration(seconds: 1), // 每次间隔 1 秒
  )
  .create();
```

### 响应缓存

缓存响应以减少网络请求：

```dart
NetOptions.instance
  .enableCache(
    enable: true,
    cacheOptions: CacheOptions(
      store: MemCacheStore(),           // 内存缓存
      policy: CachePolicy.request,      // 缓存策略
      maxStale: const Duration(days: 7), // 最大过期时间
    ),
  )
  .create();
```

### 取消请求

```dart
final cancelToken = CancelToken();

// 发起请求
final result = await get<void, Map>(
  'users',
  cancelToken: cancelToken,
);

// 取消请求
cancelRequests(cancelToken: cancelToken);
```

---

## 拦截器

### Loading 拦截器

自动管理请求时的 Loading 状态：

```dart
NetOptions.instance
  .setShowLoadingFunc(() {
    SmartDialog.showLoading();
  })
  .setDismissLoadingFunc(() {
    SmartDialog.dismiss();
  })
  .addInterceptor(LoadingInterceptor())
  .create();

// 使用时设置 isShowLoading: true
await get('users', isShowLoading: true);
```

### 异常拦截器

自动处理网络异常并显示 Toast：

```dart
NetOptions.instance
  .setShowToastFunc((msg) {
    SmartDialog.showToast(msg);
  })
  .addInterceptor(ExceptionInterceptor())
  .create();

// 使用时设置 isShowErrorToast: true
await get('users', isShowErrorToast: true);
```

### Token 刷新拦截器

自动处理 401 响应，刷新 Token 并重试请求：

```dart
NetOptions.instance
  .addInterceptor(TokenRefreshInterceptor(
    dio: NetOptions.instance.dio,
    getToken: () => TokenManager.accessToken,
    onRefresh: () async {
      final newToken = await refreshTokenAPI();
      TokenManager.accessToken = newToken;
      return newToken;
    },
  ))
  .create();
```

### 动态 Headers 拦截器

添加动态请求头：

```dart
NetOptions.instance
  .addInterceptor(HeadersInterceptor(
    staticHeaders: {
      'X-App-Version': '1.0.0',
      'X-Platform': 'iOS',
    },
    dynamicHeaders: {
      'Authorization': () => 'Bearer ${TokenManager.token}',
      'X-Timestamp': () => DateTime.now().millisecondsSinceEpoch.toString(),
    },
  ))
  .create();
```

### 自定义拦截器

```dart
class MyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 请求前处理
    print('发起请求: ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 响应处理
    print('收到响应: ${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 错误处理
    print('请求错误: ${err.message}');
    handler.next(err);
  }
}

// 添加拦截器
NetOptions.instance
  .addInterceptor(MyInterceptor())
  .create();
```

---

## 国际化

### 使用内置语言

框架内置了中文（默认）和英文支持：

```dart
// 使用英文
NetOptions.instance
  .setLocalizations(EnglishNetLocalizations())
  .create();

// 使用繁体中文
NetOptions.instance
  .setLocalizations(ZhHantNetLocalizations())
  .create();

// 切换回简体中文（默认）
NetOptions.instance
  .setLocalizations(DefaultNetLocalizations())
  .create();
```

### 自定义其他语言

实现 `NetLocalizations` 接口：

```dart
class JapaneseLocalizations implements NetLocalizations {
  @override
  String get noNetworkConnection => 'ネットワーク接続がありません';
  // ... 实现其他字段
}
```

---

## 最佳实践

### 1. 统一封装 API 服务

```dart
class UserService {
  static Future<Result<User>> getUser(int id) {
    return get<User, User>(
      'users/$id',
      fromJsonFunc: User.fromJson,
      isShowLoading: true,
    );
  }

  static Future<Result<List<User>>> getUsers({int page = 1}) {
    return get<User, List<User>>(
      'users',
      queryParameters: {'page': page},
      fromJsonFunc: User.fromJson,
    );
  }

  static Future<Result<User>> createUser(Map<String, dynamic> data) {
    return post<User, User>(
      'users',
      data: data,
      fromJsonFunc: User.fromJson,
      isShowLoading: true,
    );
  }
}
```

### 2. 在 UI 层使用

```dart
class UserListPage extends StatefulWidget { ... }

class _UserListPageState extends State<UserListPage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final result = await UserService.getUsers();
    if (result.isSuccess) {
      setState(() => users = result.data!);
    } else {
      // 错误已由 ExceptionInterceptor 处理并显示 Toast
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (_, index) => ListTile(title: Text(users[index].name)),
    );
  }
}
```

### 3. 自定义响应解码器

如果后端响应格式不是 `{code, data, msg}`：

```dart
class CustomDecoder extends NetDecoder {
  @override
  K decode<T, K>({
    required Response response,
    T? Function(dynamic)? fromJsonFunc,
  }) {
    // 假设后端格式是 {success: true, result: {...}}
    if (response.data['success'] == true) {
      final data = response.data['result'];
      if (fromJsonFunc != null) {
        return fromJsonFunc(data) as K;
      }
      return data as K;
    } else {
      throw NetException(response.data['error'], -1);
    }
  }
}

// 应用自定义解码器
NetOptions.instance
  .setHttpDecoder(CustomDecoder())
  .create();
```

---

## 常见问题

### Q: 如何处理文件上传进度？

```dart
await post(
  'upload',
  data: formData,
  onSendProgress: (sent, total) {
    print('上传进度: ${(sent / total * 100).toStringAsFixed(1)}%');
  },
);
```

### Q: 如何设置单个请求的超时？

```dart
await get(
  'slow-api',
  options: Options(
    receiveTimeout: const Duration(minutes: 5),
  ),
);
```

### Q: 如何获取原始响应（不解码）？

```dart
final result = await get<void, dynamic>('api');
// result.data 将是原始响应数据
```
