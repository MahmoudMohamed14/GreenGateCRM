import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/models/clientModel.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/services/notifi_service.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';

class ActionScreen extends StatelessWidget {

  //const ActionScreen({Key? key}) : super(key: key);
  ClientModel ?model;
  ActionScreen(this.model);

  @override
  Widget build(BuildContext context) {
    TextEditingController? noteControl=new TextEditingController();
    noteControl.text=model!.isUrl=='FromNote'?Uri.decodeFull(model!.note??'') :model!.note??'';
    LayoutCubit.get(context).dropValue= model!.state!.isNotEmpty?model!.state??'No Answer':'No Answer';
    return BlocConsumer<LayoutCubit,LayoutStates>(
        listener: (context,state){
          if(state is ClientActionSuccessState ){
            Navigator.of(context).pop(true);
            showToast(text: 'Action Done ', state: ToastState.SUCCESS);

          }else if(state is ClientGetSellerSuccessState){
          // Navigator.of(context).pop(true);
          }else if(state is ClientActionErrorState||state is ClientGetSellerErrorState){
            if(LayoutCubit.get(context).messageResult.contains("Failed host lookup: 'sjiappeg.sji-eg.com'")){

              showToast(text: 'No Internet OR Check Internet', state: ToastState.ERROR);
            }else{
              if(!Platform.isWindows)
              showToast(text: LayoutCubit.get(context).messageResult, state: ToastState.ERROR);
            }
          }

        },
    builder: (context,state){

    var cubit=  LayoutCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Action'),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(

            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.lightPrimary),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: DropdownButton(
          
                    isExpanded: true,
                    iconSize: 40,
          
                    //  elevation: 0,
                    dropdownColor: ColorManager.white,
          
          
                    value: cubit.dropValue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
          
                    onChanged: ( String?value){
          
                      cubit.dropButtonChange(vlu: value);
          
          
                    },
          
                    items:List.generate(model!.state=='Fresh Leads'?cubit.dropValueListFresh.length:cubit.dropValueList.length, (index) =>   DropdownMenuItem<String>(
          
                      child: Text(model!.state=='Fresh Leads'?cubit.dropValueListFresh[index]:cubit.dropValueList[index],style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold,fontSize: 20),),value:model!.state=='Fresh Leads'?cubit.dropValueListFresh[index] :cubit.dropValueList[index],))
                ),
              ),
             const SizedBox(height: 20,),
           defaultButton( onPress: () {
             showDatePicker(
               context: context,
               initialDate: DateTime.now(),
               firstDate: DateTime(2000),
               lastDate: DateTime(2101),
             ).then((selectedDate) {
               // After selecting the date, display the time picker.
               if (selectedDate != null) {
                 showTimePicker(
                   context: context,
                   initialTime: TimeOfDay.now(),
                 ).then((selectedTime) {
                   // Handle the selected date and time here.
                   if (selectedTime != null) {
                     DateTime selectedDateTime = DateTime(
                       selectedDate.year,
                       selectedDate.month,
                       selectedDate.day,
                       selectedTime.hour,
                       selectedTime.minute,
                     );
                     cubit.alarm=selectedDateTime.toString();
                     cubit.getEmit();
                     print(selectedDateTime); // You can use the selectedDateTime as needed.
                   }
                 });
               }
             });
           }, name: 'set alarm',height: 50,color: ColorManager.primary),
             const SizedBox(height: 10,),
              Visibility(
                visible: cubit.alarm.isNotEmpty ,
                child: Row(
                  children: [
                  const  Icon(Icons.alarm),
                    Text(' : ${cubit.alarm}',)

                  ],
                ),
              ),
          
           const   SizedBox(height: 20,),
              defaultEditText(label: 'Note',maxLine: 10,textDirection: 'g',control: noteControl),
            const  SizedBox(height: 20,),
          state is ClientActionLoadingState?CircularProgressIndicator() :   defaultButton(color: ColorManager.primary,onPress: (){
            // model!.state=cubit.dropValue;
            // model!.note=noteControl.text;
            // model!.dateCall=cubit.date;
            // model!.dateAlarm=cubit.alarm;

                cubit.actionClientSql(model!.id,cubit.dropValue, noteControl.text,cubit.date,cubit.alarm,context,model);
              }, name: 'submit')
            ],
          ),
        ),
      ),

    );
        });

  }
}
