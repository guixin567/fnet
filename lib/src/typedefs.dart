

import 'package:dio/dio.dart';
import 'entity/result.dart';

/// A function that takes a `Response` and returns a `Result<T>`.
typedef NetConverter<T> = Result<T> Function(Response response);

///网络请求报错的时候 toast 显示的回调
typedef ToastCallback = void Function(String msg);

