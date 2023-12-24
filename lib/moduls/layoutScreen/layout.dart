





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';
import 'package:greengate/moduls/screens/searchScreen.dart';
import 'package:intl/intl.dart';


class  LayoutScreen extends StatelessWidget {


  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();



  @override
  Widget build(BuildContext context) {
    var keyFormpassword=GlobalKey<FormState>();
    TextEditingController? codeControl= new TextEditingController();
    TextEditingController? newPasswordControl=new TextEditingController();
    TextEditingController? oldPassword=new TextEditingController();

    return Builder(
        builder: (context) {

          return BlocConsumer<LayoutCubit,LayoutStates>(
            listener: (context,state){},
            builder: (context,state){
              var cubit=  LayoutCubit.get(context);
              return Scaffold(
                  appBar: AppBar(
                    leadingWidth: 100,
                    leading: Row(
                      children: [
                      IconButton(onPressed: () async {
                        CacheHelper.getData(key: 'control') ?   await cubit.getAllClient():await cubit.getClientBySeller();
                       },icon:const Icon(Icons.sync),),
                       if( CacheHelper.getData(key: 'control') )   IconButton(onPressed: (){
                          showDatePicker(context: context, initialDate: DateTime.now(), firstDate:
                          DateTime.parse('2023-12-01') , lastDate: DateTime.parse('2030-12-31'))
                              .then((value){
                                cubit.getSeller(date:DateFormat.yMd().format(value!).toString() );
                                print(DateFormat.yMd().format(value).toString());
                           // expiredIDControl.text=DateFormat.yMd().format(value!);
                            cubit.getEmit();


                          }).catchError((error){
                            print('date error'+error.toString());
                          });
                        },icon:const Icon(Icons.calendar_month),),
                      ],
                    ),
                    centerTitle: true,
                    actions: [

                     cubit.indexHomeButton==1&& !CacheHelper.getData(key: 'control') ?  IconButton(onPressed: (){
                          navigateTo(context, SearchScreen(cubit.listNotCall));
                          cubit.listOfSearch=[];

                        }, icon: Icon(Icons.search,size: 20,)):SizedBox(),

                      // Platform.isWindows? Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   child: IconButton(onPressed: (){
                      //    navigateTo(context, UploadClientScreen());
                      //   }, icon: Icon(Icons.file_upload_outlined)),
                      // ):SizedBox(),
                      //this is sign out
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   child: IconButton(onPressed: (){
                      //     signOut( context);
                      //
                      //     // navigateTo(context, UploadClientScreen());
                      //   }, icon: Icon(Icons.logout_outlined)),
                      // )
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: PopupMenuButton<String>(
                          color: ColorManager.white,
                            surfaceTintColor:ColorManager.white ,

                            itemBuilder: (context)=>[
                          PopupMenuItem(child: Text('Change Password'),value: 'password',),
                          PopupMenuItem(child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.login_outlined,color: Colors.red,),
                              SizedBox(width: 20,),
                              Text('Sign Out',style: TextStyle(color: Colors.red),),
                            ],
                          ),value: 'out',),


                        ],
                            onSelected: (String value){
                              if(value=='password'){
                                showDialog(


                                    barrierDismissible: false,
                                    context: context, builder:(context )=>AlertDialog(
                                  backgroundColor: Colors.white,


                                  title: Text('Change Password'),
                                  content: Form(
                                    key: keyFormpassword,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        defaultEditText(
                                            control:codeControl,
                                            validat: ( s){
                                              bool isTrue=false;

                                              if(s!.isEmpty){
                                                return" code is empty";
                                              }if(CacheHelper.getData(key: 'myId')!= codeControl.text) isTrue=true;
                                              if(isTrue)  return "Code Not True!!!";

                                              return null;
                                            },
                                            label: "code",
                                            prefIcon: Icons.text_fields,
                                            textType: TextInputType.number
                                        ),
                                        SizedBox(height: 20,),
                                        defaultEditText(
                                          control: oldPassword,


                                          textType:TextInputType.visiblePassword,




                                          validat: ( s){
                                            bool isTrue=false;

                                            if(s!.isEmpty){
                                              return"Empty";
                                            }if(CacheHelper.getData(key: 'password')!= oldPassword.text) isTrue=true;
                                            if(isTrue)  return "Old Password Not True!!!";

                                            return null;
                                          },
                                          label: "Old Password",
                                          prefIcon: Icons.password,

                                        ),
                                        SizedBox(height: 20,),
                                        defaultEditText(
                                          control: newPasswordControl,


                                          textType:TextInputType.visiblePassword,




                                          validat: ( s){
                                            if(s!.isEmpty){
                                              return"Empty";
                                            }
                                            return null;
                                          },
                                          label: "New Password",
                                          prefIcon: Icons.password,

                                        ),
                                      ],


                                    ),
                                  ),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                      newPasswordControl.clear();
                                      codeControl.clear();
                                      oldPassword.clear();
                                    }, child: Text('Cancel',style: TextStyle(color: Colors.red),)),
                                    TextButton(onPressed: (){
                                      print(CacheHelper.getData(key: 'password'));
                                      if(keyFormpassword.currentState!.validate()){
                                       cubit.changePasswordSql(codeControl.text.trim(),newPasswordControl.text.trim(),context);

                                        // cubit.changePassword(
                                        //     code: codeControl.text,
                                        //     newPassword: newPasswordControl.text,
                                        //     context: context
                                        // );
                                        newPasswordControl.clear();
                                        oldPassword.clear();
                                        codeControl.clear();
                                      }


                                    }, child: Text('change')),

                                  ],

                                ));
                                print('password done');
                              } else if(value=='out'){
                                signOut( context);
                              }
                            },


                            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: ColorManager.primary))
                        ),
                      ),

                    ],

                    title: Text("GREEN GATE",
                        style: TextStyle(color:ColorManager.darkPrimary,
                          fontSize: 20.0,)
                    ),

                  ),
                  body:CacheHelper.getData(key: 'control')? cubit.listAdminScreen[cubit.indexHomeButton]:cubit.listScreen[cubit.indexHomeButton],
                  bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0,



                items:const <BottomNavigationBarItem>[
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
