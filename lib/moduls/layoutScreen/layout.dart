


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/addClient.dart';
import 'package:greengate/moduls/layoutScreen/design.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';
import 'package:greengate/moduls/screens/interested_screen.dart';
import 'package:greengate/moduls/screens/not_call.dart';


class  LayoutScreen extends StatelessWidget {


  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();



  @override
  Widget build(BuildContext context) {
    //TextEditingController? day=new TextEditingController();

    return Builder(
        builder: (context) {

          return BlocConsumer<LayoutCubit,LayoutStates>(
            listener: (context,state){},
            builder: (context,state){
              var cubit=  LayoutCubit.get(context);
              return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    actions: [
                      Platform.isWindows? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(onPressed: (){
                         navigateTo(context, UploadClientScreen());
                        }, icon: Icon(Icons.file_upload_outlined)),
                      ):SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(onPressed: (){
                          signOut( context);

                          // navigateTo(context, UploadClientScreen());
                        }, icon: Icon(Icons.logout_outlined)),
                      )
                    ],

                    title: Text("GREEN GATE",
                        style: TextStyle(color:ColorManager.darkPrimary,
                          fontSize: 20.0,)
                    ),

                  ),
                  body:CacheHelper.getData(key: 'control')? cubit.listAdminScreen[cubit.indexHomeButton]:cubit.listScreen[cubit.indexHomeButton],
                  bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 0,



                items: CacheHelper.getData(key: 'control')? const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(Icons.menu,),label: 'Menu'),
                  BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: 'home'),

                ]:const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(icon: Icon(Icons.menu,),label: 'Menu'),
                    BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: 'home'),
                  BottomNavigationBarItem(icon: Icon(Icons.add),label: 'Add Client'),

                  ],
                onTap: (index){


                  cubit.changeHomeButton(index);
                },
                currentIndex: cubit.indexHomeButton,),);
            } ,

          );
        }
    );

  }

}
