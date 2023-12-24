
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';


class  UploadClientScreen extends StatelessWidget {





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

                    title: Text("Upload Sudden And Normal   ${cubit.valuepross.toInt()}",
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
                  body:  cubit.clientList.isNotEmpty?Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [


                        Expanded(

                          child: ListView.builder(
                          
                            physics: ClampingScrollPhysics(),
                            itemCount: cubit.clientList.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Center(child: Text("${cubit.clientList[index][0]}"))),
                          
                          
                                      Expanded(child: Text("${cubit.clientList[index][1]}")),
                          
                                     Expanded(child: Center(child: Text("${cubit.clientList[index][2]}"))),
                          
                                     cubit.isFreshLead? Expanded(child: Center(child: Text("${cubit.clientList[index][3]}"))):SizedBox(),
                          
                                    ],
                                  ),
                                  const  SizedBox(height: 10,),
                                ],
                              );
                          
                            },
                          
                          ),
                        ),
                        const  SizedBox(height: 20,),
                        cubit.clientList.isNotEmpty ? ElevatedButton(

                          child:  Text("Upload",style: TextStyle(color: ColorManager.white),),
                          onPressed:(){

                           cubit.insertClienSql();




                          },
                        ): const SizedBox(),
                      ],
                    ),
                  ):
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      defaultButton(color: ColorManager.primary,onPress: (){
                        cubit.pickFileReview();
                      }, name: 'Fetch File Normal Client '),
                      SizedBox(height: 20,),
                      defaultButton(color:ColorManager.primary,onPress: (){
                        cubit.pickFileReview(isLead: true);
                      }, name: 'Fetch File Fresh Leads '),

                    ],),
                  )
              );
            } ,

          );
        }
    );

  }

}
