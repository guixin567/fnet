import 'package:fnet/src/config/net_options.dart';

/// A custom exception class for network errors.
class NetException implements Exception {
  final String? _message;

  /// Get the error message.
  /// Falls back to localized default error message if not set.
  String get message =>
      _message ?? NetOptions.instance.localizations.defaultError;

  final int? _code;

  /// Get the error code. Defaults to -1 if not set.
  int get code => _code ?? -1;

  NetException([this._message, this._code]);

  @override
  String toString() {
    return 'NetException(code: $code, message: $message)';
  }
}
