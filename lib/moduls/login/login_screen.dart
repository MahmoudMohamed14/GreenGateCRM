
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/constant/color_manager.dart';
import 'package:greengate/moduls/layoutScreen/layout.dart';
import 'package:greengate/moduls/layoutScreen/layout_cubit.dart';
import 'package:greengate/moduls/login/cubit/login_cubit.dart';
import 'package:greengate/moduls/login/cubit/login_state.dart';



class LoginScreen extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    TextEditingController? email= TextEditingController();
    TextEditingController? password= TextEditingController();

    var keyForm=GlobalKey<FormState>();






    return BlocProvider<LoginCubit>(
      create:(context)=>LoginCubit() ,
      child: BlocConsumer<LoginCubit,LoginState>(
          listener: (context,state){
            if(state is LoginSuccessState){
              navigateAndFinish(context, LayoutScreen());
              if(CacheHelper.getData(key: 'control')) {
                LayoutCubit.get(context).getAllClient();
              } else {
                LayoutCubit.get(context).getClientBySeller();
              }
              LayoutCubit.get(context).getEmit();
            }
            else if (state is LoginErrorState){
              showToast( state: ToastState.ERROR, text: state.error!);
            }

          },
          builder: (context,state){
           var cubit=LoginCubit.get(context);
            return Scaffold(
             // backgroundColor: ColorManager.primary,
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: keyForm,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: const BoxDecoration(

                                image: DecorationImage(image:  AssetImage('assets/logo.jpg')),
                                shape: BoxShape.circle
                              ),

                            ),
                          ),
                          const SizedBox(height: 20,),
                          Text('Welcome Green Gate',style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.w900,fontSize: 25),),
                        const   SizedBox(height: 30,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,

                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  const SizedBox(height: 20,),

                                  //  Text('${getLang(context, "login_name")}', style:Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black),),
                                  //  SizedBox(height: 10,),
                                  // Text('login now to ', style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54,fontSize: 18),),

                                  defaultEditText(
                                      control: email,
                                      validat: ( s){
                                        if(s!.isEmpty){
                                          return"Code is empty";
                                        }
                                        return null;
                                      },
                                      label: "Code",
                                      prefIcon: Icons.email_outlined,
                                      textType: TextInputType.text
                                  ),

                                  const SizedBox(height: 20,),
                                  defaultEditText(isSuffix: true,control: password,
                                      validat: ( s){
                                        if(s.isEmpty){
                                          return "password empty";
                                        }
                                        return null;
                                      },
                                      textType:TextInputType.visiblePassword,
                                      enable: cubit.isScure,

                                      sufIcon: cubit.suffix,
                                      label:  "password",

                                      prefIcon:Icons.password,//Icons.lock,
                                      onPressSuffix: (){
                                       cubit.passwordLogin();

                                      }
                                  ),
                                  const SizedBox(height: 30,),
                                  state is LoginLoadingState?const Center(child: CircularProgressIndicator()) :


                                  defaultButton(color: ColorManager.primary,
                                      onPress: () async {
                                        if(keyForm.currentState!.validate()){

                                         await cubit.loginSql(email.text, password.text);



                                        //  here you code


                                        }else{
                                        }
                                      },
                                      name:  "login"),




                                ],),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },

        ),
    );



  }
}