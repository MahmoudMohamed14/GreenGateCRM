import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/models/clientModel.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';

class InsertClientScreen extends StatelessWidget {

 const InsertClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController? phoneControl=new TextEditingController();
    TextEditingController? nameControl=new TextEditingController();
    TextEditingController? codeControl= new TextEditingController();
    TextEditingController? passwordControl=new TextEditingController();
    TextEditingController? confirmPasswordControl=new TextEditingController();
    TextEditingController? nameRegistControl=new TextEditingController();

    var keyForm=GlobalKey<FormState>();
    return  BlocConsumer<LayoutCubit,LayoutStates>(
        listener: (context,state){},
    builder: (context,state){
          var cubit=  LayoutCubit.get(context);
          return  CacheHelper.getData(key: 'control')? Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: keyForm,
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(20)
                      //   ),
                      //   child: Image(
                      //
                      //       width: 150,
                      //       height: 150,
                      //       image: AssetImage('assets/sjilogo.jpg')
                      //   ),
                      // ),
                      SizedBox(height: 20,),
                      Text('Register ',style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.w900,fontSize: 25),),
                      SizedBox(height: 30,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              SizedBox(height: 20,),


                              defaultEditText(
                                  control: codeControl,
                                  validat: ( s){
                                    if(s!.isEmpty){
                                      return"Code is empty";
                                    }
                                    return null;
                                  },
                                  label: "Code",
                                  prefIcon: Icons.email_outlined,
                                  textType: TextInputType.text
                              ),
                              SizedBox(height: 20,),
                              defaultEditText(
                                  control: nameRegistControl,
                                  validat: ( s){
                                    if(s!.isEmpty){
                                      return"Code is empty";
                                    }
                                    return null;
                                  },
                                  label: "Name",
                                  prefIcon: Icons.email_outlined,
                                  textType: TextInputType.text
                              ),

                              SizedBox(height: 20,),
                              defaultEditText(isSuffix: true,control: passwordControl,
                                validat: ( s){
                                  if(s.isEmpty){
                                    return "password empty";
                                  }
                                  return null;
                                },
                                textType:TextInputType.visiblePassword,
                                // enable: cubit.isScure,

                                //  sufIcon: cubit.suffix,
                                label:  "Password",

                                prefIcon:Icons.password,//Icons.lock,
                                // onPressSuffix: (){
                                //   cubit.passwordLogin();
                                //
                                // }
                              ),

                              SizedBox(height: 20,),

                              state is RegisterSQLLoadingState?Center(child: CircularProgressIndicator()) :


                              defaultButton(color: ColorManager.primary,
                                  onPress: () async {
                                    if(keyForm.currentState!.validate()){

                                      await cubit.registerSql(codeControl.text, nameRegistControl.text, passwordControl.text);



                                      //here you code


                                    }else{
                                    }
                                  },
                                  name:  "Add"),
                              //  SizedBox(height: 20,),

                              // SizedBox(height: 15,),
                              //change Password
                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     TextButton(onPressed: (){
                              //       AttendCubit.get(context).getAttendanceUser();
                              //       showDialog(
                              //
                              //
                              //           barrierDismissible: false,
                              //           context: context, builder:(context )=>AlertDialog(
                              //
                              //         title: Text('Change Password'),
                              //         content: Form(
                              //           key: keyFormpassword,
                              //           child: Column(
                              //             mainAxisSize: MainAxisSize.min,
                              //             children: [
                              //               defaultEditText(
                              //                   control:codeControl,
                              //                   validat: ( s){
                              //                     if(s!.isEmpty){
                              //                       return" code is empty";
                              //                     }
                              //                     return null;
                              //                   },
                              //                   label: "code",
                              //                   prefIcon: Icons.text_fields,
                              //                   textType: TextInputType.number
                              //               ),
                              //               SizedBox(height: 20,),
                              //               defaultEditText(
                              //                 control: oldPassword,
                              //
                              //
                              //                 textType:TextInputType.visiblePassword,
                              //
                              //
                              //
                              //
                              //                 validat: ( s){
                              //                   bool isTrue=false;
                              //
                              //                   if(s!.isEmpty){
                              //                     return"Empty";
                              //                   }else{
                              //                     listOfAttenduserGl.forEach((element) {
                              //                       if(element['id']==codeControl.text && element['password']==oldPassword.text){
                              //                         isTrue=true;
                              //                       }
                              //
                              //                     });
                              //                     if(!isTrue) return 'password Wrong';
                              //
                              //                   }
                              //                   return null;
                              //                 },
                              //                 label: "Old Password",
                              //                 prefIcon: Icons.password,
                              //
                              //               ),
                              //               SizedBox(height: 20,),
                              //               defaultEditText(
                              //                 control: newPasswordControl,
                              //
                              //
                              //                   textType:TextInputType.visiblePassword,
                              //
                              //
                              //
                              //
                              //                   validat: ( s){
                              //                     if(s!.isEmpty){
                              //                       return"Empty";
                              //                     }
                              //                     return null;
                              //                   },
                              //                   label: "New Password",
                              //                   prefIcon: Icons.password,
                              //
                              //               ),
                              //             ],
                              //
                              //
                              //           ),
                              //         ),
                              //         actions: [
                              //           TextButton(onPressed: (){
                              //             Navigator.pop(context);
                              //             newPasswordControl.clear();
                              //             codeControl.clear();
                              //           }, child: Text('Cancel',style: TextStyle(color: Colors.red),)),
                              //           TextButton(onPressed: (){
                              //         if(keyFormpassword.currentState!.validate()){
                              //           cubit.changePassword(
                              //               code: codeControl.text,
                              //               newPassword: newPasswordControl.text,
                              //               context: context
                              //           );
                              //           newPasswordControl.clear();
                              //           oldPassword.clear();
                              //           codeControl.clear();
                              //         }
                              //
                              //
                              //           }, child: Text('change')),
                              //
                              //         ],
                              //
                              //       ));
                              //     }, child: Text('Change password?',style: TextStyle(color: ColorManager.darkPrimary),)),
                              //   ],
                              //
                              // )
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text("noHaveAccount_name"),
                              //     defaultTextButton(onPress: (){
                              //
                              //       //  cubit.getClassName();
                              //      //  navigateTo(context, Register());
                              //
                              //
                              //
                              //
                              //     }, name: '${getLang(context, "register_name")}')
                              //   ],),



                            ],),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ):Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                defaultEditText(label: 'Number',textType: TextInputType.phone,prefIcon: Icons.phone,control: phoneControl),
                const SizedBox(height: 20,),
                defaultEditText(label: 'Name',control: nameControl),
                const SizedBox(height: 20,),
              state is AddClientLoadingState?CircularProgressIndicator():  defaultButton(onPress: () async {
                 await  cubit.insertManualSql(ClientModel(
                    phone:"2${phoneControl.text.trim()}" ,
                    name: nameControl.text,
                    seller: CacheHelper.getData(key: 'myId'),
                    date: cubit.date
                  ));

                }, name: 'Add',color: ColorManager.primary,)

              ],
            ),
          );
        });
  }
}
