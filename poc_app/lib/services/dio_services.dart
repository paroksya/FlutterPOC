import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'app_urls.dart';
import 'error_model.dart';

class HttpService {
  late Dio _dio;
  HttpService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppUrls.apiUrl,
        responseType: ResponseType.json,
        sendTimeout: const Duration(seconds: 180),
        connectTimeout: const Duration(seconds: 180),
        receiveTimeout: const Duration(seconds: 180),
      ),
    );

    if (!kIsWeb) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
                return true;
              };
          return client;
        },
      );
    }
    initializeInterceptors();
  }

  void initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          log("Url  => ${options.uri}");
          // String? userToken = LocalStorageService.getAuthenticationToken();
          // if (userToken.isNotEmpty) {
          //   options.headers["Authorization"] = "Bearer $userToken";
          // }
          options.headers["Connection"] = "keep-alive";
          if (options.data.runtimeType == FormData) {
            final data = options.data as FormData;
            for (var element in data.fields) {
              log("${element.key}:${element.value}");
            }
            for (var element in data.files) {
              log("${element.key}:${element.value.filename}");
            }
          } else {
            log("Body => ${options.data ?? {}}");
          }
          log("Header => ${options.headers}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // log("OnResponse => ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response != null) {}
          return handler.next(e);
        },
      ),
    );
  }

  //Get Method
  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.get(endPoint, queryParameters: data);
    } on DioException catch (e) {
      responseErrorHandler(response: e.response, dioErrorType: e.type);
      return e.response ??
          Response(requestOptions: RequestOptions(), data: e.response?.data);
    }
  }

  //Post Method
  Future<Response> post({
    required String endPoint,
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        endPoint,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      responseErrorHandler(response: e.response, dioErrorType: e.type);
      return e.response ??
          Response(requestOptions: RequestOptions(), data: e.response?.data);
    }
  }

  //Update Method
  Future<Response> put({
    dynamic data,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        endPoint,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      responseErrorHandler(response: e.response, dioErrorType: e.type);
      return e.response ??
          Response(requestOptions: RequestOptions(), data: e.response?.data);
    }
  }

  //Delete Method
  Future<Response> delete({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _dio.delete(
        endPoint,
        queryParameters: queryParameters,
        data: data,
      );
    } on DioException catch (e) {
      responseErrorHandler(response: e.response, dioErrorType: e.type);
      return e.response ??
          Response(requestOptions: RequestOptions(), data: e.response?.data);
    }
  }
}

void responseErrorHandler({
  Response? response,
  DioExceptionType? dioErrorType,
}) {
  try {
    if (response?.statusCode != null && response?.statusCode == 410) {
    } else {
      final model = ErrorModel.fromJson(response?.data ?? {});
      model.error?.message ?? model.errorString ?? "";
    }
  } catch (e, t) {
    log(e.toString() + t.toString());
    log("message: Server Error");
  }
  if (response?.statusCode == 200) {
    log("Successfully GET - 200 ${response?.data}");
  } else if (response?.statusCode == 201) {
    log("Successfully POST - 201 ${response?.data}");
  } else if (response?.statusCode == 401) {
    log("Invalid AUTH Token - 401 ${response?.data}");
  } else if (response?.statusCode == 400) {
    log("Invalid AUTH Token - 400 ${response?.data}");
  } else if (response?.statusCode == 404) {
    log("Not Found - 404 ${response?.data}");
  } else if (response?.statusCode == 422) {
    log("Un-Processable Entity - 422 ${response?.data}");
  } else if (response?.statusCode == 500) {
    log("Server Error - 500 ${response?.data}");
  } else if (response?.statusCode == 403) {
    log("Forbidden - 403 ${response?.data}");
  } else if (dioErrorType == DioExceptionType.unknown ||
      dioErrorType == DioExceptionType.connectionTimeout ||
      dioErrorType == DioExceptionType.sendTimeout) {
    log("No Network Found $dioErrorType ${response?.data ?? ""}");
  } else {
    log("Some Went Wrong - ${response?.data ?? ""}");
  }
}
