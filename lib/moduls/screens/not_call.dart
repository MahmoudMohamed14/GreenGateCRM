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
 TextEditingController? searchControl=new TextEditingController();

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
                   // reverse: true,


                    shrinkWrap: true,
                    physics:  const ClampingScrollPhysics(),
                    itemCount: cubit.listNotCall.length,
                    scrollDirection: Axis.vertical,

                    itemBuilder: (context, index) {
                      return Design.newClentModel(cubit.listNotCall.reversed.toList()[index],context,index);

                    }

                ),
              ):Center(child: CircularProgressIndicator());
            } ,

          );
        }
    );

  }



}