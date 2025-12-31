import 'net_localizations.dart';

/// Traditional Chinese implementation of [NetLocalizations].
class ZhHantNetLocalizations implements NetLocalizations {
  const ZhHantNetLocalizations();

  @override
  String get noNetworkConnection => '無網路連接，請檢查您的網路設置';

  @override
  String get connectionTimeout => '連接超時，請檢查網路連接';

  @override
  String get sendTimeout => '請求超時，請稍後重試';

  @override
  String get receiveTimeout => '響應超時，請檢查網路連接';

  @override
  String get badRequest => '參數異常';

  @override
  String get unauthorized => '未授權，可能需要登錄';

  @override
  String get forbidden => '禁止訪問，您沒有權限';

  @override
  String get notFound => '未找到請求的資源';

  @override
  String get internalServerError => '服務異常，請稍後重試';

  @override
  String get serverError => '服務異常，請稍後重試';

  @override
  String get requestCancelled => '請求被取消';

  @override
  String get badCertificate => '證書異常';

  @override
  String get connectionError => '本地網路異常';

  @override
  String get defaultError => '請求出錯';

  @override
  String get unknownError => '服務異常，請稍後重試';
}
