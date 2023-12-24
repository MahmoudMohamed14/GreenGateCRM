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
class  SearchScreen extends StatelessWidget {


  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

late List<ClientModel>listModel;
  SearchScreen(this.listModel);

  @override
  Widget build(BuildContext context) {
   // TextEditingController? searchControl=new TextEditingController();

    return Builder(
        builder: (context) {


          return BlocConsumer<LayoutCubit,LayoutStates>(
            listener: (context,state){},
            builder: (context,state){
              var cubit=  LayoutCubit.get(context);
              return  Scaffold(
                appBar:  AppBar(),
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      defaultEditText(label: 'Search',prefIcon: Icons.search,onchange: (value){
                        cubit.search(value, listModel);
                      }),
                     const  SizedBox(height: 20,),
                      cubit.listOfSearch.isNotEmpty?  Expanded(

                        child: ListView.builder(
                            key: listKey,
                            // reverse: true,


                            shrinkWrap: true,
                            physics:  const ClampingScrollPhysics(),
                            itemCount: cubit.listOfSearch.length,
                            scrollDirection: Axis.vertical,

                            itemBuilder: (context, index) {
                              return Design.newClentModel(cubit.listOfSearch.reversed.toList()[index],context,index);

                            }

                        ),
                      ):Center(child: Text("No Result !!",style: TextStyle(color: ColorManager.primary,fontSize: 20,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),

              );
            } ,

          );
        }
    );

  }



}