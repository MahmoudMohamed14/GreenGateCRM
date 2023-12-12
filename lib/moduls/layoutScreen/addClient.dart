
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    actions:[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(onPressed: (){
                          cubit.updateValueSql('name',value: "test",id: 2);
                         cubit.pickFileReview();
                        }, icon: Icon(Icons.file_upload_outlined)),
                      )
                    ],
                  ),
                  body:  cubit.clientList.isNotEmpty?RefreshIndicator(
                    onRefresh:  () async{
                      RefreshProgressIndicator();
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [


                            ListView.builder(

                              physics: NeverScrollableScrollPhysics(),
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

                                       // Expanded(child: Center(child: Text("${cubit.clientList[index][2]}"))),


                                      ],
                                    ),
                                    const  SizedBox(height: 10,),
                                  ],
                                );

                              },

                            ),
                            const  SizedBox(height: 20,),
                            cubit.clientList.isNotEmpty ? Column(
                              children: [


                                const SizedBox(height: 20,),




                                ElevatedButton(
                                  child:  Text("Upload"),
                                  onPressed:(){

                                   cubit.insertClienSql();




                                  },
                                ),

                              ],
                            ): const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ):SizedBox()
              );
            } ,

          );
        }
    );

  }

}
