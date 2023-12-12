
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/componant/remote/dioHelper.dart';
import 'login_state.dart';
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  bool isScure=true;
  IconData suffix = Icons.visibility_off;
  static LoginCubit get(context){
    return BlocProvider.of(context);
  }

  void passwordLogin(){

    isScure = !isScure;
    suffix= isScure?Icons.visibility_off :Icons.visibility;
    emit(LoginPasswordState());

  }
  Future loginSql(String username, String password,{bool notLogin=false})  async {
    if(username.isNotEmpty&password.isNotEmpty) {
   emit(LoginLoadingState());
      // var url = Uri.parse('https://sjiappeg.sji-eg.com/login.php');// Replace with your PHP script URL
      try {
        Response response = await DioHelper.dio.post('login.php',
            queryParameters: {'code': username, 'password': password});
        if (response.statusCode == 200) {
          var res = json.decode(response.data);
          if (res.length > 0) {
            CacheHelper.putData(key: 'isLogin', value: true);
            CacheHelper.putData(key: 'myId', value: res[0]['code']);
            if (res[0]['controller'] == 'true') {
              CacheHelper.putData(key: 'control', value: true);}else{
              CacheHelper.putData(key: 'control', value: false);
            }


           emit(LoginSuccessState());


          print(response.statusCode);
        } else {
          emit(LoginErrorState(error: " Error !!!!!!!!! "));

          print('Login failed: ${response.data.toString()}');
        }

        }
      } catch (error) {
        emit(LoginErrorState(error: "Login onError : ${error.toString()}"));

        print('Login onError: ${error.toString()}');
        print(onError);
      }
    }

  }


}