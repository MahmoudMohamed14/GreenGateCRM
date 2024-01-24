import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';


class  ErrorClientScreen extends StatelessWidget {





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
                    leading: IconButton(onPressed: (){
                      Navigator.pop(context);
                      cubit.listErrorModel.clear();
                    }, icon: Icon(Icons.arrow_back_rounded)),

                    title: Text("Error length= ${cubit.listErrorModel.length}",
                        style: TextStyle(color:ColorManager.darkPrimary,
                          fontSize: 20.0,)
                    ),
                    // actions:[
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //     child: IconButton(onPressed: (){
                    //       //cubit.updateValueSql('name',value: "test",id: 2);
                    //    //  cubit.pickFileReview();
                    //     }, icon: Icon(Icons.file_upload_outlined)),
                    //   )
                    // ],
                  ),
                  body:  cubit.listErrorModel.isNotEmpty?Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [


                        Expanded(

                          child: ListView.builder(

                            physics: ClampingScrollPhysics(),
                            itemCount: cubit.listErrorModel.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Text("phone : ${cubit.listErrorModel[index].phone}"),
                                  const  SizedBox(height: 10,),
                                  Text("number in excel: ${cubit.listErrorModel[index].id}"),
                                  const  SizedBox(height: 10,),
                                  Text("Error : ${cubit.listErrorModel[index].message}"),
                                  const  SizedBox(height:3,),
                                  Container(height: 3,width: double.infinity,color: Colors.black,),
                                  const  SizedBox(height:3,),
                                ],
                              );

                            },

                          ),
                        ),

                      ],
                    ),
                  ):SizedBox()
              );
            } ,

          );
        }
    );

  }}