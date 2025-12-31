import 'package:dio/dio.dart';
import 'entity/result.dart';

/// A function that takes a [Response] and returns a [Result<T>].
/// Used for custom response conversion.
typedef NetConverter<T> = Result<T> Function(Response response);

/// Toast callback function for displaying error messages.
typedef ToastCallback = void Function(String msg);
