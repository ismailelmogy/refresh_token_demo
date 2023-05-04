import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../features/change_language/data/datasources/lang_local_data_source.dart';
import '../utils/app_strings.dart';

class AppIntercepters extends Interceptor {
  final Dio client;
  final LangLocalDataSource langLocalDataSource;
  // final AuthLocalDataSource authLocalDataSource;
  AppIntercepters(
      {required this.langLocalDataSource,
      // required this.authLocalDataSource,
      required this.client});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[HttpHeaders.acceptHeader] = ContentType.json;
    String lang = await langLocalDataSource.getSavedLang();
    options.headers[AppStrings.lang] = lang;
    // UserModel? authenticatedUser =
    //     await authLocalDataSource.getSavedLoginCredentials();
    // if (authenticatedUser != null) {
    //   options.headers[HttpHeaders.authorizationHeader] =
    //       AppStrings.bearer + authenticatedUser.token!;
    // }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    if (err.response?.statusCode == 401) {
      // UserModel? authenticatedUser =
      //     await authLocalDataSource.getSavedLoginCredentials();
      // if (authenticatedUser != null) {
      // if (await _refreshToken(
      //   authenticatedUser,
      // )) {
      //   return handler.resolve(await _retry(err.requestOptions));
      // }
      // }
    }
    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return client.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  // Future<bool> _refreshToken(UserModel authenticatedUser) async {
  // final response = await client.post(EndPoints.refreshToken, data: {
  //   AppStrings.token: authenticatedUser.token,
  //   AppStrings.refreshToken: authenticatedUser.refreshToken,
  // });
  // final jsonResponse = Commons.decodeJson(response);
  // BaseResponseModel baseResponse = BaseResponseModel.fromJson(jsonResponse);
  // if (baseResponse.isSuccess!) {
  //   authenticatedUser.token = baseResponse.data["token"];
  //   authenticatedUser.refreshToken = baseResponse.data["refreshToken"];
  //   authLocalDataSource.saveLoginCredentials(userModel: authenticatedUser);
  //   return true;
  // } else {
  //   return false;
  // }
  // }
}
