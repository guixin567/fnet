import 'net_localizations.dart';

/// English implementation of [NetLocalizations].
class EnglishNetLocalizations implements NetLocalizations {
  const EnglishNetLocalizations();

  @override
  String get noNetworkConnection => 'No network connection, please check your settings';

  @override
  String get connectionTimeout => 'Connection timeout, please check your network';

  @override
  String get sendTimeout => 'Request timeout, please try again later';

  @override
  String get receiveTimeout => 'Response timeout, please check your network';

  @override
  String get badRequest => 'Bad request';

  @override
  String get unauthorized => 'Unauthorized, please login first';

  @override
  String get forbidden => 'Access denied, you do not have permission';

  @override
  String get notFound => 'Resource not found';

  @override
  String get internalServerError => 'Server error, please try again later';

  @override
  String get serverError => 'Server error, please try again later';

  @override
  String get requestCancelled => 'Request cancelled';

  @override
  String get badCertificate => 'Certificate error';

  @override
  String get connectionError => 'Connection error';

  @override
  String get defaultError => 'Request failed';

  @override
  String get unknownError => 'Unknown error, please try again later';
}
