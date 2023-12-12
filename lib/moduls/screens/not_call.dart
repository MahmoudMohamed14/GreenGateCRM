import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/models/clientModel.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/constant/icon_broken.dart';
import 'package:greengate/moduls/layoutScreen/design.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';
import 'package:greengate/moduls/screens/actionscreen.dart';
class  NotCallScreen extends StatelessWidget {


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
              return  cubit.listNotCall.isNotEmpty?Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                    key: listKey,


                    shrinkWrap: true,
                    physics:  const ClampingScrollPhysics(),
                    itemCount: cubit.listNotCall.length,
                    scrollDirection: Axis.vertical,

                    itemBuilder: (context, index) {
                      return Design.newClentModel(cubit.listNotCall[index],context,index);

                    }

                ),
              ):Center(child: CircularProgressIndicator());
            } ,

          );
        }
    );

  }


  Widget newClentModel(ClientModel model,context,index){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:  const EdgeInsets.all(10),

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
                //mainAxisSize: MainAxisSize.min,

                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize:MainAxisSize.min ,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${model.name}',style: TextStyle(fontWeight:FontWeight.bold,color:LayoutCubit.get(context).indexSelect ==index?ColorManager.white:ColorManager.primary),),
                        const SizedBox(height: 10,),
                        Text('${model.phone}',style: TextStyle(color: LayoutCubit.get(context).indexSelect ==index?ColorManager.white:Colors.grey,),),
                      ],),
                  ),
                  const Spacer(),

                GestureDetector(onTap: () async {
                   await LayoutCubit.get(context).whatsApp(model.phone);

                },child: const   CircleAvatar(child: Image(image:AssetImage('assets/whats.png'),fit: BoxFit.fill),radius: 12,)),
                const SizedBox(width: 10,),
                 IconButton(onPressed: (){

                    LayoutCubit.get(context).indexOfListSelect(index);
                    LayoutCubit.get(context).makeCall('+${model.phone}').then((value) {
                      navigateTo(context, ActionScreen(model));

                    });

                  }, icon: Icon(Icons.phone,color:  ColorManager.primary,))
                ],
              ),
              SizedBox(height: 20,),
              Text('${model.note} ',textDirection: TextDirection.rtl,style:  TextStyle(color: LayoutCubit.get(context).indexSelect ==index?ColorManager.white:Colors.grey,))
            ],
          ),
        ),
        const SizedBox(height: 20,)
      ],
    );
  }

}