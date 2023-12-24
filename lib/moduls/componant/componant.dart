

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/constant/test_styles_manager.dart';
import 'package:greengate/moduls/login/login_screen.dart';


Widget defaultButton(
    {
      required Function onPress,
      required String name,
      double width=double.infinity,
      double height=50,
      Color color = const Color(0xff002d61)





    }
    )=>Container(
  decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: color



  ) ,


  height: height,
  width:width ,
  child: MaterialButton(



    onPressed: () {
      onPress();

    },
    child: Text(
      name.toUpperCase(),
      style: getBoldStyle(color: ColorManager.white),
    ),),
);
Widget defaultEditText(
    {
      bool isSuffix=false,
      String? textDirection='',
      TextEditingController?   control,
      required String label,
      IconData? prefIcon,
      Function ?onPressSuffix,
      Function()?onPress,
      Function(String s)?onsubmitted,
      Function(String s)?onchange,
      IconData? sufIcon,
      int ?maxLine=1,

      FormFieldValidator? validat,
      bool enable=false,
      bool enableText=true,
      TextInputType ?textType,
      int?maxlength
    }
    )
{

  return TextFormField(
maxLength:maxlength ,
      textDirection: textDirection!.isEmpty ?TextDirection.ltr:TextDirection.rtl,

      validator: validat,
      obscureText: enable,
      controller: control,
      keyboardType:textType ,
      autocorrect: false,
      cursorColor: ColorManager.primary,
      decoration:InputDecoration(

          errorStyle: TextStyle(color: Colors.red),

          enabledBorder: OutlineInputBorder(


              borderSide: BorderSide(color: ColorManager.primary),

              borderRadius:BorderRadius.circular(10)),
          focusedBorder:OutlineInputBorder(


              borderSide: BorderSide(color: ColorManager.primary),

              borderRadius:BorderRadius.circular(10)) ,

          errorBorder:OutlineInputBorder(


              borderSide: BorderSide(color: Colors.red),

              borderRadius:BorderRadius.circular(10)) ,
          focusedErrorBorder: OutlineInputBorder(


              borderSide: BorderSide(color: Colors.red),

              borderRadius:BorderRadius.circular(10)),

          labelStyle: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold,fontSize: 20),
          labelText: label,
          prefixIcon: Icon(prefIcon,color: ColorManager.primary,),

          suffixIcon: isSuffix?IconButton(onPressed:(){

            if(onPressSuffix!=null){
              onPressSuffix();
            }
          },icon: Icon(sufIcon,),):null


      ) ,
      onTap: (){

        if(onPress!=null){
          onPress();
        }

      },
      onChanged: ( s){
        if(onchange!=null){
          onchange(s);
        }
      },
     onFieldSubmitted: (s){
       if(onsubmitted!=null){
         onsubmitted(s);
       }
     },
      enabled: enableText,
      maxLines:maxLine

  );

}
Widget defaultTextButton({
  required Function onPress,
  required String name,})=> TextButton(child: Text(name.toUpperCase(),style: getBoldStyle(color: ColorManager.primary),),onPressed: (){onPress();},);
void navigateTo(context,widget ){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));
}
void navigateAndFinish(context,widget ){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>widget),(route)=>false);
}
enum ToastState{SUCCESS,ERROR,WARNING}
void showToast({ required String text,required ToastState state}){
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: toastColor(state: state),
      textColor: Colors.white,
      fontSize: 16.0
  );


}
Color toastColor({
  required ToastState state
}){
  late Color color;
  switch(state){
    case ToastState.SUCCESS:
      color= Colors.green;
      break;
    case ToastState.ERROR:
      color= Colors.red;
      break;
    case ToastState.WARNING:
      color= Colors.yellow;
      break;

  }
  return color;
}

void signOut( context) {


  CacheHelper.removeWithKey(key: 'isLogin');
  CacheHelper.removeWithKey(key: 'myId');
   CacheHelper.removeWithKey(key: 'control');
  CacheHelper.removeWithKey(key: 'password');


 navigateAndFinish(context, LoginScreen());



}
Widget launcherScreen({bool? iscurrentuser,required Widget loginScreen ,required Widget homeScreen }){
  Widget launch=loginScreen;
  if(iscurrentuser!){
  launch=homeScreen;
  }else {
    launch=loginScreen;
  }
  return launch;
}