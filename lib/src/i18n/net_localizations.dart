/// Internationalization interface for network error messages.
/// Users can implement this interface to provide custom translations.
abstract class NetLocalizations {
  /// No network connection error message
  String get noNetworkConnection;

  /// Connection timeout error message
  String get connectionTimeout;

  /// Send timeout error message
  String get sendTimeout;

  /// Receive timeout error message
  String get receiveTimeout;

  /// Bad request (400) error message
  String get badRequest;

  /// Unauthorized (401) error message
  String get unauthorized;

  /// Forbidden (403) error message
  String get forbidden;

  /// Not found (404) error message
  String get notFound;

  /// Internal server error (500) error message
  String get internalServerError;

  /// Default server error message
  String get serverError;

  /// Request cancelled error message
  String get requestCancelled;

  /// Bad certificate error message
  String get badCertificate;

  /// Local network error message
  String get connectionError;

  /// Default request error message
  String get defaultError;

  /// Unknown error message
  String get unknownError;
}
