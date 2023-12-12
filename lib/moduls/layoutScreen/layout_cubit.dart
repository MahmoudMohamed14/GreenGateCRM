
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greengate/models/clientModel.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/componant/remote/dioHelper.dart';
import 'package:greengate/moduls/layoutScreen/layout_status.dart';
import 'package:greengate/moduls/screens/adminScreen.dart';
import 'package:greengate/moduls/screens/homeScreen.dart';
import 'package:greengate/moduls/screens/insert_client_screen.dart';
import 'package:greengate/moduls/screens/not_call.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';




class LayoutCubit extends Cubit< LayoutStates> {
  LayoutCubit () : super( LayoutInitState());

  static LayoutCubit  get(context) {
    return BlocProvider.of(context);
  }
  String? filePathClient;
  List<ClientModel> clientListModel=[];
  List<List<dynamic>> clientList= [];
String date=DateFormat.yMd().format(DateTime.now());
  pickFileReview() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      clientList = [];
      print(result.files.first.name);
      filePathClient = result.files.first.path!;

      final input = File(filePathClient!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      clientList  = fields;
      print(fields.length);
      print( clientList.length);

     // reviewListModel=[];

      for (int i = 0; i <fields.length; i++) {


        clientListModel.add(ClientModel(

          name: fields[i][0].toString().trim(),
         phone: fields[i][1].toString().trim(),
         seller: fields[i][2].toString().trim(),
         date:date








        ));



      }

      emit(FetchStateSuccess());
      print(clientListModel[1].phone);
      PlatformFile file = result.files.first;
      print(clientList.length);

      print(file.name);

      print(file.size);
      print(file.extension);
      print(file.path);
    }


    else {
// User canceled the picker
    }


  }
  double valuepross=0;

  Future updateValueSql(String ky , {int? id,String? value})  async {
   // String val='';
   // emit(HiringCallLoadingState());
    // valuepross=0;
   // late HiringModel model;

    try{
      Response response=await DioHelper.dio.post('valueupdateclient.php',queryParameters: {'key':ky,'value':value,'id':id});
      if(response.statusCode==200){
       // print(i);
        // valuepross=(i+1)/suddenNormalList.length*100;
        //getEmit();

        print("###############################");
        print(response.data);

      }
    }catch(error){
      print("Sudden Normal upload "+error.toString());
      //emit(HiringCallErrorState());

    }



  }
  Future updateclientSql( int? id,String state,String note,context)  async {
  emit(ClientActionLoadingState());
    try{
      Response response=await DioHelper.dio.post('editClient.php',queryParameters: {'id':id,'state':state,'note':note});
      if(response.statusCode==200){
        // print(i);
        // valuepross=(i+1)/suddenNormalList.length*100;
        //getEmit();
        emit(ClientActionSuccessState());
        Navigator.of(context).pop(true);
        await getClientBySeller();

        print("###############################");
        print(response.data);

      }
    }catch(error){
      emit(ClientActionErrorState());
      print("Clint Action "+error.toString());
      //emit(HiringCallErrorState());

    }



  }
  getEmit(){
    emit(EmitLayout ());
  }
  int indexHomeButton=0;
  void changeHomeButton(ind){

    indexHomeButton=ind;
    emit(ChangeHomeButton());
  }
  Future insertManualSql(ClientModel model)  async {
    emit(AddClientLoadingState());


      try{
        Response response=await DioHelper.dio.post('insertClient.php',queryParameters:model.toMap());
        if(response.statusCode==200){
         // print(i);
        //  valuepross=(i+1)/clientList.length*100;
          getEmit();
          print("###############################");
          print(response.data);

            emit(AddClientSuccessState());
            await getClientBySeller();

        }
      }catch(error){
        emit(AddClientErrorState());
        print("Add Manual "+error.toString());

      }










  }

  Future insertClienSql()  async {
    emit(AddClientLoadingState());
    valuepross=0;

    for(int i=0;i< clientList.length;i++){

      try{
        Response response=await DioHelper.dio.post('insertClient.php',queryParameters: clientListModel[i].toMap());
        if(response.statusCode==200){
          print(i);
          valuepross=(i+1)/clientList.length*100;
          getEmit();
          print("###############################");
          print(response.data);
          if(valuepross.toInt()==100){
            clientList.clear();
            emit(AddClientSuccessState());
          }
        }
      }catch(error){
        emit(AddClientErrorState());
        print("Sudden Normal upload "+error.toString());

      }







    }


  }

  List<ClientModel>listAllClient=[];
  List<ClientModel>listInterested=[];
  List<ClientModel>listClosedCall=[];
  List<ClientModel>listNoAnswer=[];
  List<ClientModel>listNotInterested=[];
  List<ClientModel>listFollowUP=[];
  List<ClientModel>listFollowMeeting=[];
  List<ClientModel>listNotCall=[];
  //List<String>listGrid=['Not Call','No Answer Potential','Cold Call','No Answer','Not Interested','Follow UP','Follow Meeting'];
 List<String>listSeller=[];
  Future<void> getAllClient() async {
    emit(ClientGetLoadingState());

    try{
      Response response=await  DioHelper.dio.post('getclient.php' );
      if (response.statusCode == 200 ) {
        var res=json.decode(response.data);
        //  showToast(text: value.data.toString(), state: ToastState.SUCCESS);
        if(res.length>0){
          listSeller=[];
          listAllClient=[];
          listInterested=[];
          listClosedCall=[];
          listNoAnswer=[];
          listNotInterested=[];
          listFollowUP=[];
          listFollowMeeting=[];
          listNotCall=[];
          print(res);

          res.forEach((element){
            if(element['state']=='Interested') {
              listInterested.add(ClientModel.fromJson(element));
            } else if(element['state']=='Closed') {
              listClosedCall.add(ClientModel.fromJson(element));
            } else if(element['state']=='No Answer') {
              listNoAnswer.add(ClientModel.fromJson(element));
            } else if(element['state']=='Not Interested') {
              listNotInterested.add(ClientModel.fromJson(element));
            } else if(element['state']=='Follow UP') {
              listFollowUP.add(ClientModel.fromJson(element));
            } else if(element['state']=='Follow Meeting') {
              listFollowMeeting.add(ClientModel.fromJson(element));
            } else {
              listNotCall.add(ClientModel.fromJson(element));
            }
            listSeller.add(element['seller']);

            listAllClient.add(ClientModel.fromJson(element));
            //myDepartList.add(element['depart']);
          });


          //print(res);
          print(listAllClient.length.toString()+"  = lenth");
         emit(ClientGetSuccessState());
          //getMyList();

        }

        print(response.statusCode);

      } else {print('Get All Data Error: ${response.data}');}
    }catch(onError){
     emit(ClientGetErrorState());

      print('Get All Data Error: ${onError.toString()}');
      print(onError);
    }

  }
  Future<void> getClientBySeller() async {
    emit(ClientGetSellerLoadingState());

    try{
      Response response=await  DioHelper.dio.post('getClientid.php',queryParameters:{'seller':"${CacheHelper.getData(key: 'myId')}"} );
      if (response.statusCode == 200 ) {
        var res=json.decode(response.data);
        //  showToast(text: value.data.toString(), state: ToastState.SUCCESS);
        if(res.length>0){
          listAllClient=[];
          listInterested=[];
          listClosedCall=[];
          listNoAnswer=[];
          listNotInterested=[];
          listFollowUP=[];
          listFollowMeeting=[];
          listNotCall=[];
        //  print(res);

          res.forEach((element){
            if(element['state']=='Interested') {
              listInterested.add(ClientModel.fromJson(element));
            } else if(element['state']=='Closed') {
              listClosedCall.add(ClientModel.fromJson(element));
            } else if(element['state']=='No Answer') {
              listNoAnswer.add(ClientModel.fromJson(element));
            } else if(element['state']=='Not Interested') {
              listNotInterested.add(ClientModel.fromJson(element));
            } else if(element['state']=='Follow UP') {
              listFollowUP.add(ClientModel.fromJson(element));
            } else if(element['state']=='Follow Meeting') {
              listFollowMeeting.add(ClientModel.fromJson(element));
            } else {
              listNotCall.add(ClientModel.fromJson(element));
            }

            listAllClient.add(ClientModel.fromJson(element));
            //myDepartList.add(element['depart']);
          });
          //print(res);
          print(listAllClient.length.toString()+"  = lenth");
          emit(ClientGetSellerSuccessState());
          //getMyList();

        }

        print(response.statusCode);

      } else {print('Get All Data Error: ${response.data}');}
    }catch(onError){
      emit(ClientGetSellerErrorState());

      print('Get All Data Error: ${onError.toString()}');
      print(onError);
    }

  }
  List<Widget>listScreen=[HomeScreen(),NotCallScreen(),InsertClientScreen()];
  List<Widget>listAdminScreen=[HomeScreen(),MonitorScreen()];

  Future makeCall(String phone) async {
    Uri uri=Uri(scheme: 'tel', path: '${phone}');
    await launchUrl(uri);
  }
  int indexSelect=0;
void  indexOfListSelect(index){
  indexSelect=index;
  getEmit();

}
  String dropValue='No Answer';
  List<String>dropValueList=['Interested','Closed','No Answer','Not Interested','Follow UP','Follow Meeting'];
  void dropButtonChange({vlu}) {
    dropValue = vlu;
    emit(HiringDropState ());
  }
void getSeller(seller){
  listInterested=[];
  listClosedCall=[];
  listNoAnswer=[];
  listNotInterested=[];
  listFollowUP=[];
  listFollowMeeting=[];
  listNotCall=[];
    listAllClient.forEach((element) {
      if(element.seller==seller){
      if(element.state=='Interested') {
        listInterested.add(element);
      }
      else if(element.state=='Closed') {
        listClosedCall.add(element);
      }
      else if(element.state=='No Answer') {
        listNoAnswer.add(element);
      }
      else if(element.state=='Not Interested') {
        listNotInterested.add(element);
      }
      else if(element.state=='Follow UP') {
        listFollowUP.add(element);
      }
      else if(element.state=='Follow Meeting') {
        listFollowMeeting.add(element);
      }
      else {
        listNotCall.add(element);
      }}

    });
    getEmit();
}
Future<void> whatsApp(num) async {
    Uri uri= Uri.parse('whatsapp://send?phone=$num&&text=');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Handle error, e.g., show an error dialog
      print('Could not launch WhatsApp');
    }
}


}