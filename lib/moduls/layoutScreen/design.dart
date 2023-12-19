import 'package:flutter/material.dart';
import 'package:greengate/models/clientModel.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/constant/test_styles_manager.dart';
import 'package:greengate/moduls/screens/actionscreen.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/screens/closed_screen.dart';
import 'package:greengate/moduls/screens/follow_meeting.dart';
import 'package:greengate/moduls/screens/follow_up.dart';
import 'package:greengate/moduls/screens/no_answer.dart';
import 'package:greengate/moduls/screens/interested_screen.dart';
import 'package:greengate/moduls/screens/not_call.dart';
import 'package:greengate/moduls/screens/not_interested.dart';
class Design{
 static Widget newClentModel(ClientModel model,context,index){
    return Column(
      children: [
        Stack(
         children: [
           Container(
             padding:  const EdgeInsets.all(13),

             decoration: BoxDecoration(
                 border: Border.all(color: ColorManager.primary,),


                 borderRadius: BorderRadius.circular(10),
                 color:LayoutCubit.get(context).indexSelect ==index?ColorManager.grey:Colors.white
             ),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   //mainAxisSize: MainAxisSize.min,

                   children: [
                     Expanded(
                       child: Column(
                         mainAxisSize:MainAxisSize.min ,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Text('${model.name}',style: TextStyle(fontWeight:FontWeight.bold,color:LayoutCubit.get(context).indexSelect ==index?ColorManager.white:ColorManager.primary),),

                           Text('${model.phone}',style: TextStyle(color: LayoutCubit.get(context).indexSelect ==index?ColorManager.white:Colors.grey,),),
                          // SizedBox(height: 10,),
                           Visibility(
                             visible: model.dateAlarm!.isNotEmpty,
                               child: Text('${model.dateAlarm}',style: TextStyle(color: LayoutCubit.get(context).indexSelect ==index?ColorManager.white:Colors.grey,),)),

                         ],),
                     ),
                     const  Spacer(),
                     GestureDetector(onTap: () async {
                       await LayoutCubit.get(context).whatsApp(model.phone);

                     },child: const   CircleAvatar(child: Image(image:AssetImage('assets/whats.png'),fit: BoxFit.fill),radius: 12,)),
                     const SizedBox(width: 10,),
                     IconButton(onPressed: (){
                       LayoutCubit.get(context).alarm='';
                       // LayoutCubit.get(context).whatsApp('+${model.phone}');
                       LayoutCubit.get(context).indexOfListSelect(index);
                       LayoutCubit.get(context).makeCall('+${model.phone}').then((value) {
                         navigateTo(context, ActionScreen(model));

                       });

                     }, icon: Icon(Icons.phone,color:  ColorManager.primary,))
                   ],
                 ),
                 SizedBox(height: 20,),
                 model.note!.isNotEmpty? Text('${model.note} ',textDirection: TextDirection.rtl,style:  TextStyle(color: LayoutCubit.get(context).indexSelect ==index?ColorManager.white:Colors.grey,)):const SizedBox(),
                 SizedBox(height: 20,),
                 defaultButton(onPress: (){
                   LayoutCubit.get(context).alarm='';
                   navigateTo(context, ActionScreen(model));
                 }, name: 'action',color: ColorManager.lightPrimary)
               ],
             ),
           ),
           CacheHelper.getData(key: 'control')?Align(
             alignment: Alignment.topRight,
               child: CircleAvatar(child: Text("${model.seller}",style: TextStyle(color: ColorManager.white),),radius: 10,backgroundColor: ColorManager.lightPrimary,)):SizedBox()
         ],
        ),
        SizedBox(height: 20,)
      ],
    );
  }

 static  Widget layoutDesign(context,title,length){
   return Container(
     height: 150,
     alignment: Alignment.center,
     decoration: BoxDecoration(
         color:  ColorManager.primary,
         borderRadius: BorderRadius.circular(10)),
     child: Padding(
       padding: const EdgeInsets.all(20),
       child: Column(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Center(child: Text('${title}',style: getBoldStyle(color: Colors.white,fontSize: 18),)),
           SizedBox(height: 5,),

           Text('${length}',style: getBoldStyle(color: Colors.white,fontSize: 17),),

         ],
       ),
     ),
   );
 }

 static Widget sellerDesign(context,text){
   return  GestureDetector(
     onTap: (){
       LayoutCubit.get(context).sellerId=text;
       LayoutCubit.get(context).getSeller();
       LayoutCubit.get(context).changeHomeButton(0);
     },
     child: Column(
      // mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Center(
           child: Container(
             width: double.infinity,
             padding:  const EdgeInsets.all(10),

             decoration: BoxDecoration(
                 border: Border.all(color: ColorManager.primary,),


                 borderRadius: BorderRadius.circular(10),
                 color:Colors.white
             ),
             child: Center(child: Text('${text}',style: getBoldStyle(color: ColorManager.primary,fontSize: 20,))),
           ),
         ),
         SizedBox(height: 20,)
       ],
     ),
   );
 }
}

