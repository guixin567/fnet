import 'dart:io';

/// A wrapper class for API response data.
/// Provides a unified result structure for network requests.
class Result<T> {
  /// Response status code
  int? code;

  /// Response message
  String? msg;

  /// Response data
  T? data;

  /// Check if the request was successful based on status code.
  bool get isSuccess => HttpStatus.ok == code;

  Result._internal({this.code, this.msg, this.data});

  /// Create a successful result.
  factory Result.success(T data, {String? msg}) {
    return Result._internal(code: HttpStatus.ok, msg: msg, data: data);
  }

  /// Create a failure result.
  factory Result.failure({int? code, String? msg}) {
    return Result._internal(code: code, msg: msg);
  }

  @override
  String toString() {
    return 'Result(code: $code, msg: $msg, data: $data)';
  }
}
