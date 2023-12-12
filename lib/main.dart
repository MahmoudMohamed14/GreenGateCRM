import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:greengate/bloc_observer.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/componant/remote/dioHelper.dart';
import 'package:greengate/moduls/constant/theme_manager.dart';
import 'package:greengate/moduls/layoutScreen/addClient.dart';
import 'package:greengate/moduls/layoutScreen/layout.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';
import 'package:greengate/moduls/login/login_screen.dart';

import 'package:upgrader/upgrader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

//import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  await initialization();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
 await CacheHelper.init();

  runApp(MyApp(),);

}
Future initialization() async {

  // print('ready in 3...');
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        CacheHelper.getData(key: 'isLogin')!=null?CacheHelper.getData(key: 'control')??false?BlocProvider<LayoutCubit>(create: (context)=>LayoutCubit()..getAllClient()):BlocProvider<LayoutCubit>(create: (context)=>LayoutCubit()..getClientBySeller()): BlocProvider<LayoutCubit>(create: (context)=>LayoutCubit())

      ],
      
     child: BlocListener<LayoutCubit,LayoutStates>(
       listener: (context,state){
               // if(  CacheHelper.getData(key: 'isLogin')!=null){
               //   if(CacheHelper.getData(key: 'control')) LayoutCubit.get(context).getAllClient();
               //   else LayoutCubit.get(context).getClientBySeller();
               // }

        // PermissionCubit.get(context).getEmit();





       },

       child: MaterialApp(
           title: 'Flutter Demo',
           debugShowCheckedModeBanner: false,
           theme: getApplicationTheme(context),
           home:launcherScreen(iscurrentuser: CacheHelper.getData(key: 'isLogin')??false,homeScreen: LayoutScreen(),loginScreen: LoginScreen()) //LayoutScreen()//const MyHomePage(title: 'Flutter Demo Home Page'),
       ),
     ),
    );
  }
}

