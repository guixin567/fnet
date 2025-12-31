import 'net_localizations.dart';

/// Default Chinese implementation of [NetLocalizations].
class DefaultNetLocalizations implements NetLocalizations {
  const DefaultNetLocalizations();

  @override
  String get noNetworkConnection => '无网络连接，请检查您的网络设置';

  @override
  String get connectionTimeout => '连接超时，请检查网络连接';

  @override
  String get sendTimeout => '请求超时，请稍后重试';

  @override
  String get receiveTimeout => '响应超时，请检查网络连接';

  @override
  String get badRequest => '参数异常';

  @override
  String get unauthorized => '未授权，可能需要登录';

  @override
  String get forbidden => '禁止访问，您没有权限';

  @override
  String get notFound => '未找到请求的资源';

  @override
  String get internalServerError => '服务异常，请稍后重试';

  @override
  String get serverError => '服务异常，请稍后重试';

  @override
  String get requestCancelled => '请求被取消';

  @override
  String get badCertificate => '证书异常';

  @override
  String get connectionError => '本地网络异常';

  @override
  String get defaultError => '请求出错';

  @override
  String get unknownError => '服务异常，请稍后重试';
}
