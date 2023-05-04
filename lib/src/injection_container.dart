import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'features/change_language/change_lang_injection_container.dart';
import 'features/drawer_navigation/presentation/bloc/drawer_navigation_bloc.dart';

final serviceLocator = GetIt.instance;
Future<void> init() async {
  // Blocs
  serviceLocator
      .registerFactory<DrawerNavigationBloc>(() => DrawerNavigationBloc());

// features
  initChangeLanguageFeature();

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => Dio());
  serviceLocator.registerLazySingleton<ApiConsumer>(
      () => DioConsumer(client: serviceLocator()));
  serviceLocator.registerLazySingleton(() => LogInterceptor(
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
      request: true,
      requestBody: true));
  serviceLocator.registerLazySingleton(() => AppIntercepters(
      client: serviceLocator(), langLocalDataSource: serviceLocator()));
}
