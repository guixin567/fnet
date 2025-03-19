import 'dart:io';

import 'package:fnet/fnet.dart';


/// 默认解码器
class DefaultNetDecoder extends NetDecoder {
  /// 单例对象
  static final DefaultNetDecoder _instance = DefaultNetDecoder._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DefaultNetDecoder._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DefaultNetDecoder.getInstance() => _instance;

  @override
  K decode<T, K>({required Response<dynamic> response, T? Function(dynamic)? fromJsonFunc}) {
    var code = response.data[paramCode];

    /// 请求成功[业务错误]
    if (code == HttpStatus.ok) {
      var data = response.data[paramData];
      if (fromJsonFunc != null && data is List) {
        var dataList = List<T>.from(data.map((item) => fromJsonFunc(item)).toList()) as K;
        return dataList;
      }
      if (fromJsonFunc != null) {
        var model = fromJsonFunc(data) as K;
        return model;
      }
      return data as K;
    } else {
      var errorMsg = response.data[paramMsg];
      throw NetException(errorMsg, code);
    }
  }
}
