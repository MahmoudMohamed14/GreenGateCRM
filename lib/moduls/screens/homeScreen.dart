import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/layoutScreen/design.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';
import 'package:greengate/moduls/screens/closed_screen.dart';
import 'package:greengate/moduls/screens/follow_meeting.dart';
import 'package:greengate/moduls/screens/follow_up.dart';
import 'package:greengate/moduls/screens/no_answer.dart';
import 'package:greengate/moduls/screens/interested_screen.dart';
import 'package:greengate/moduls/screens/not_interested.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state){},
    builder: (context,state){
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: GestureDetector(onTap: (){
                      navigateTo(context,FollowMeetingScreen());
                    },child: Design.layoutDesign(context,'Follow Meeting',LayoutCubit.get(context).listFollowMeeting.length))),

                    SizedBox(width: 20,),
                    Expanded(child: GestureDetector(onTap: (){
                        navigateTo(context,FollowUpScreen());
                    },child:Design. layoutDesign(context,'Follow UP',LayoutCubit.get(context).listFollowUP.length))),

                  ],
                ),
                // List<String>dropValueList=['No Answer Potential','Cold Call','No Answer','Not Interested','Follow UP','Follow Meeting'];

                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: GestureDetector(onTap: (){
                      navigateTo(context, InterestedScreen());
                    },child: Design.layoutDesign(context,'Interested',LayoutCubit.get(context).listInterested.length))),

                    SizedBox(width: 20,),
                    Expanded(child: GestureDetector(onTap: (){
                      navigateTo(context, ClosedScreen());
                    },child:Design. layoutDesign(context,'Closed',LayoutCubit.get(context).listClosedCall.length))),

                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: GestureDetector(onTap: (){
                      navigateTo(context, NotAnswerScreen());
                    },child: Design.layoutDesign(context,'No Answer',LayoutCubit.get(context).listNoAnswer.length))),

                    SizedBox(width: 20,),
                    Expanded(child: GestureDetector(onTap: (){
                      navigateTo(context, NotInterestedScreen());
                    },child:Design. layoutDesign(context,'Not Interested',LayoutCubit.get(context).listNotInterested.length))),

                  ],
                ),
                SizedBox(height: 20,),
                Visibility(

                  child: Row(
                    children: [
                      Expanded(child: GestureDetector(onTap: (){
                        //  navigateTo(context, NotAnswerScreen());
                      },child: Design.layoutDesign(context,'Not Call Yet',LayoutCubit.get(context).listNotCall.length))),
                      // const SizedBox(width: 20,),
                      // Expanded(child: GestureDetector(onTap: (){
                      //   //  navigateTo(context, NotAnswerScreen());
                      // },child: Design.layoutDesign(context,'Called',LayoutCubit.get(context).listNotCall.length))),


                    ],
                  ),

                ),

              ],
            ),
          ),
        );
    }

    );
  }
}
