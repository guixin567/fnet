
import 'dart:io';

/// A wrapper class for the data that we want to return from the API.
 class Result<T>{

  int? code;
  String? msg;
  T? data;

  bool get isSuccess => HttpStatus.ok == code;

  Result._internal({this.code, this.msg, this.data});

  ///接口成功
  factory Result.success(T data,{String? msg}){
   return Result._internal(code: HttpStatus.ok, msg: msg, data: data);
  }

  ///接口失败
  factory Result.failure({int? code,String? msg}){
   return Result._internal(code: code, msg: msg);
  }
}




