import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/models/clientModel.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';

class InsertClientScreen extends StatelessWidget {

 const InsertClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController? phoneControl=new TextEditingController();
    TextEditingController? nameControl=new TextEditingController();
    return  BlocConsumer<LayoutCubit,LayoutStates>(
        listener: (context,state){},
    builder: (context,state){
          var cubit=  LayoutCubit.get(context);
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                defaultEditText(label: 'Number',textType: TextInputType.phone,prefIcon: Icons.phone,control: phoneControl),
                const SizedBox(height: 20,),
                defaultEditText(label: 'Name',control: nameControl),
                const SizedBox(height: 20,),
              state is AddClientLoadingState?CircularProgressIndicator():  defaultButton(onPress: () async {
                 await  cubit.insertManualSql(ClientModel(
                    phone:"2${phoneControl.text.trim()}" ,
                    name: nameControl.text,
                    seller: CacheHelper.getData(key: 'myId'),
                    date: cubit.date
                  ));

                }, name: 'Add',color: ColorManager.primary,)

              ],
            ),
          );
        });
  }
}
