import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:greengate/bloc_observer.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/layoutScreen/layout.dart';
import 'package:greengate/moduls/login/login_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/componant/remote/dioHelper.dart';
import 'package:greengate/moduls/componant/services/notifi_service.dart';
import 'package:greengate/moduls/constant/theme_manager.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';

import 'package:upgrader/upgrader.dart';




void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  //await initialization();
  NotificationService().initNotification(

  );

  NotificationService.onNotification.stream.listen((event) {
    print(event);
    showToast(text: event+'main', state: ToastState.SUCCESS);
  });
  tz.initializeTimeZones();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
 await CacheHelper.init();

  runApp(MyApp(),);

}


class MyApp extends StatelessWidget  with WidgetsBindingObserver  {
  const MyApp({super.key});
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      showToast(text: 'resumed', state: ToastState.WARNING);

    }else if(state == AppLifecycleState.inactive){
      showToast(text: 'INTER', state: ToastState.SUCCESS);
      // app is inactive
    }else if(state == AppLifecycleState.paused){
      showToast(text: 'Paused', state: ToastState.WARNING);
    }else if(state == AppLifecycleState.detached){
      showToast(text: 'Delete', state: ToastState.ERROR);
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        CacheHelper.getData(key: 'isLogin')!=null?CacheHelper.getData(key: 'control')??false?BlocProvider<LayoutCubit>(create: (context)=>LayoutCubit()..getAllClient()..changeHomeButton(0)..getSellerByDepartSql()):BlocProvider<LayoutCubit>(create: (context)=>LayoutCubit()..getClientBySeller()..changeHomeButton(0)): BlocProvider<LayoutCubit>(create: (context)=>LayoutCubit())

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

           debugShowCheckedModeBanner: false,
           theme: getApplicationTheme(context),

           home:launcherScreen(iscurrentuser: CacheHelper.getData(key: 'isLogin')??false,homeScreen: LayoutScreen(),loginScreen: LoginScreen()), //LayoutScreen()//const MyHomePage(title: 'Flutter Demo Home Page'),
       ),
     ),
    );
  }
}

