import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/models/clientModel.dart';
import 'package:greengate/moduls/componant/componant.dart';
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
    noteControl.text=model!.note??'';
    LayoutCubit.get(context).dropValue= model!.state!.isNotEmpty?model!.state??'No Answer':'No Answer';
    return BlocConsumer<LayoutCubit,LayoutStates>(
        listener: (context,state){
          if(state is ClientActionSuccessState ){
            showToast(text: 'Action Done Wait TO GET Data', state: ToastState.SUCCESS);
          }else if(state is ClientGetSellerSuccessState){
            Navigator.of(context).pop(true);
          }else if(state is ClientActionErrorState||state is ClientGetSellerErrorState){
            if(LayoutCubit.get(context).messageResult.contains("Failed host lookup: 'sjiappeg.sji-eg.com'")){
              showToast(text: 'No Internet OR Check Internet', state: ToastState.ERROR);
            }else{
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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

                  items:List.generate(cubit.dropValueList.length, (index) =>   DropdownMenuItem<String>(

                    child: Text(cubit.dropValueList[index],style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold,fontSize: 20),),value: cubit.dropValueList[index],))
              ),
            ),
            SizedBox(height: 20,),
            defaultEditText(label: 'Note',maxLine: 10,textDirection: 'g',control: noteControl),
            SizedBox(height: 20,),
        state is ClientActionLoadingState?CircularProgressIndicator() :   defaultButton(color: ColorManager.primary,onPress: (){
              cubit.updateclientSql(model!.id,cubit.dropValue, noteControl.text,context);
            }, name: 'submit')
          ],
        ),
      ),

    );
        });

  }
}
