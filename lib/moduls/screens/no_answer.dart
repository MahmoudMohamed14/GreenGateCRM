import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/design.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';
class  NotAnswerScreen extends StatelessWidget {


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

                    title: Text("NOT Answer",
                        style: TextStyle(color:ColorManager.darkPrimary,
                          fontSize: 20.0,)
                    ),

                  ),
                  body:  cubit.listNoAnswer.isNotEmpty?Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                      key: listKey,

                      physics: ClampingScrollPhysics(),
                      itemCount: cubit.listNoAnswer.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Design.newClentModel(cubit.listNoAnswer[index],context,index);

                      }

                    ),
                  ):Center(child: CircularProgressIndicator())
              );
            } ,

          );
        }
    );

  }

}