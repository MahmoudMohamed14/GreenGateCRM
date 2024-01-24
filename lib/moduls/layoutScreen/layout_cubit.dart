
import 'dart:convert';
import 'dart:io';


import 'package:csv/csv.dart';
import 'package:dio/dio.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:greengate/models/clientModel.dart';
import 'package:greengate/models/errorModel.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:greengate/moduls/componant/local/cache_helper.dart';
import 'package:greengate/moduls/componant/remote/dioHelper.dart';
import 'package:greengate/moduls/componant/services/notifi_service.dart';
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
  String alarm='';
  List<ClientModel> clientListModel=[];
  List<List<dynamic>> clientList= [];
String date=DateFormat.yMd().format(DateTime.now());
  bool isFreshLead = false;
  pickFileReview({bool isLead = false}) async {
    isFreshLead=isLead;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: false,
    );


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

          name: fields[i][0].toString().trim().replaceAll("'", ""),
          phone: fields[i][1].toString().trim(),
          seller: fields[i][2].toString().trim(),
           state: isLead?fields[i][3].toString().trim():'',
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
List<ErrorModel>listErrorModel=[];
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
  String messageResult='';
  bool removeFromNoteCall=true;
  String whereAreFromScreen='';
  void actionLocal(ClientModel model){
    
    if(model.state=='Fresh Leads') {

      listFreshLead.add(model);
     

    }
    else if(model.state=='False Number') {
      listNumberFalse.add(model);
    }
    else if(model.state=='Closed') {
      listClosedCall.add(model);
    }
    else if(model.state=='Done Deal') {
      listDealDone.add(model);
    }
    else if(model.state=='No Answer') {
      listNoAnswer.add(model);
    }
    else if(model.state=='Not Interested') {
      listNotInterested.add(model);
    }
    else if(model.state=='Follow UP') {
      listFollowUP.add(model);
    }
    else if(model.state=='Follow Meeting') {
      listFollowMeeting.add(model);
    }

    if(removeFromNoteCall){ listNotCall.remove(model);
    }else{
      if(whereAreFromScreen=='Fresh Leads') {

        listFreshLead.remove(model);


      } 
      else if(whereAreFromScreen=='False Number') {
        listNumberFalse.remove(model);
      }
      else if(whereAreFromScreen=='Closed') {
        listClosedCall.remove(model);
      }
      else if(whereAreFromScreen=='Done Deal') {
        listDealDone.remove(model);
      }
      else if(whereAreFromScreen=='No Answer') {
        listNoAnswer.remove(model);
      }
      else if(whereAreFromScreen=='Not Interested') {
        listNotInterested.remove(model);
      }
      else if(whereAreFromScreen=='Follow UP') {
        listFollowUP.remove(model);
      }
      else if(whereAreFromScreen=='Follow Meeting') {
        listFollowMeeting.remove(model);
      }
    }

    if(model.dateAlarm!.isNotEmpty && !(DateTime.now().isAfter(DateTime.parse(model.dateAlarm??'')))){ NotificationService().scheduleNotification(
        id: model.id,
        title: '${model.name} (${model.phone})',
        body: '${model.note}',
        payLoad:'+${model.phone}' ,

        scheduledNotificationDateTime: DateTime.parse(model.dateAlarm??''));
    //print(element['dateAlarm']);
    }
    getEmit();
  }
  Future actionClientSql(  id, state,String note,dateCall,dateAlarm,context,model)  async {
  emit(ClientActionLoadingState());
  messageResult='';
    try{
      Response response=await DioHelper.dio.post('editClient.php', options:Options(
         headers: {
      //'Content-Type': 'application/x-www-form-urlencoded',
      // Add any other headers if required
      }
      ),queryParameters: {'id':id,"state":state,"note":note,"dateCall":dateCall,"dateAlarm":dateAlarm});
      if(response.statusCode==200){
        print(response.data.toString());


        if(response.data.toString().contains('ActionSuccess'))model!.state=state;
        model!.note=note;
        model!.dateCall=dateCall;
        model!.dateAlarm=dateAlarm;
          {


            messageResult=response.data.toString();
            actionLocal( model);
            emit(ClientActionSuccessState());
           // Navigator.of(context).pop(true);
          //  await getClientBySeller();
          }


        print("###############################");
        print(response.data);

      }else{

        print(response.statusCode.toString()+"*** from else"+response.data.toString());
        messageResult=response.data.toString();
        emit(ClientActionErrorState());
      }

    }catch(error){

      if(error.toString().contains('This exception was thrown because the response has a status code of 403 and RequestOptions.validateStatus was configured to throw for this status code')){
        actionClientErrorSql(  id, state,note,dateCall,dateAlarm,context,model);
      }else{
        messageResult=error.toString();
        emit(ClientActionErrorState());
        print("##### from catch"+"Clint Action "+error.toString());
      }
      //emit(HiringCallErrorState());

    }



  }
  Future actionClientErrorSql(  id, state,String note,dateCall,dateAlarm,context,model)  async {
    emit(ClientActionLoadingState());
    messageResult='';
    try{
      Response response=await DioHelper.dio.post('editClient.php', options:Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            // Add any other headers if required
          }
      ),queryParameters: {'id':id,"state":state,"note":Uri.encodeFull(note),"dateCall":dateCall,"dateAlarm":dateAlarm,'isUrl':'FromNote'});
      if(response.statusCode==200){


        if(response.data.toString().contains('ActionSuccess'))
        {
          model!.state=state;
          model!.note=note;
          model!.dateCall=dateCall;
          model!.dateAlarm=dateAlarm;
          messageResult=response.data.toString();
          actionLocal( model);
          emit(ClientActionSuccessState());
           //Navigator.of(context).pop(true);
         // await getClientBySeller();
        }


        print("###############################");
        print(response.data);

      }else{

        print(response.statusCode.toString()+"*** from else"+response.data.toString());
        messageResult=response.data.toString();
        emit(ClientActionErrorState());
      }

    }catch(error){
      messageResult=error.toString();
      emit(ClientActionErrorState());
      print("##### from catch"+"Clint Action "+error.toString());
      //emit(HiringCallErrorState());

    }



  }
  getEmit(){
    emit(EmitLayout ());
  }
  int indexHomeButton=0;
  void changeHomeButton(ind){
    ind==1?removeFromNoteCall=true:removeFromNoteCall=false;

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
         // getEmit();
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
    listErrorModel=[];

    for(int i=0;i< clientList.length;i++){

      try{
        Response response=await DioHelper.dio.post('insertClient.php',queryParameters: clientListModel[i].toMap());
        if(response.statusCode==200){
         if(!response.data.toString().contains("client inserted successfully")) listErrorModel.add(ErrorModel(id: i+1,phone: clientListModel[i].phone,message: response.data.toString()));

          print(i);
          valuepross=(i+1)/clientList.length*100;
          getEmit();
          print("###############################");
          print(response.data);
          if(valuepross.toInt()==100){
            clientList.clear();
            emit(AddClientSuccessState());
          }
        }else{
          listErrorModel.add(ErrorModel(id: i+1,phone: clientListModel[i].phone,message: response.data.toString()));
          emit(AddClientErrorState());

        }
      }catch(error){
        listErrorModel.add(ErrorModel(id: i+1,phone: clientListModel[i].phone,message: error.toString()));
        emit(AddClientErrorState());

        print("Sudden Normal upload "+error.toString());

      }







    }


  }

  List<ClientModel>listAllClient=[];
  List<ClientModel>listNumberFalse=[];
  List<ClientModel>listClosedCall=[];
  List<ClientModel>listNoAnswer=[];
  List<ClientModel>listNotInterested=[];
  List<ClientModel>listFollowUP=[];
  List<ClientModel>listFollowMeeting=[];
  List<ClientModel>listDealDone=[];
  List<ClientModel>listNotCall=[];
  List<ClientModel>listFreshLead=[];

  //List<String>listGrid=['Not Call','No Answer Potential','Cold Call','No Answer','Not Interested','Follow UP','Follow Meeting'];
 List<String>listSeller=[];
 String loadingGet='ok';
  Future<void> getAllClient() async {
    sellerId='';
    messageResult='';
    loadingGet='';

    emit(ClientGetLoadingState());

    try{
      Response response=await  DioHelper.dio.post('getclient.php' );
      if (response.statusCode == 200 ) {
        listSeller=[];
        listAllClient=[];
        listNumberFalse=[];
        listClosedCall=[];
        listNoAnswer=[];
        listNotInterested=[];
        listFollowUP=[];
        listDealDone=[];
        listFollowMeeting=[];
        listNotCall=[];
        listFreshLead=[];
        var res=json.decode(response.data);
        //  showToast(text: value.data.toString(), state: ToastState.SUCCESS);
        if(res.length>0){


         // print(res);

          res.forEach((element){
             if(element['state']=='Closed') {

              listClosedCall.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Done Deal') {

              listDealDone.add(ClientModel.fromJson(element));
            } else if(element['state']=='False Number') {
               listNumberFalse.add(ClientModel.fromJson(element));
             }
            else if(element['state']=='No Answer') {

              listNoAnswer.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Not Interested') {

              listNotInterested.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Follow UP') {

              listFollowUP.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Follow Meeting') {

              listFollowMeeting.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Fresh Leads') {

              listFreshLead.add(ClientModel.fromJson(element));
            }
            else if(element['state'].toString().isEmpty){
              listNotCall.add(ClientModel.fromJson(element));
            }
            listSeller.add(element['seller']);

            listAllClient.add(ClientModel.fromJson(element));
            //myDepartList.add(element['depart']);
          });


          //print(res);
          print(listAllClient.length.toString()+"  = lenth");
          loadingGet='ok';
         emit(ClientGetSuccessState());
          //getMyList();

        }

        print(response.statusCode);

      } else {
        print('Get All Data Error: ${response.data}');
        messageResult=response.data.toString();
        loadingGet='ok';
        emit(ClientGetErrorState());
      }
    }catch(onError){
      loadingGet='ok';
     emit(ClientGetErrorState());
     messageResult=onError.toString();
      print('Get All Data Error: ${onError.toString()}');
      print(onError);
    }

  }
  Future<void> getClientBySeller() async {
    loadingGet='';

    emit(ClientGetSellerLoadingState());
    messageResult='';
    try{
      Response response=await  DioHelper.dio.post('getClientid.php',queryParameters:{'seller':"${CacheHelper.getData(key: 'myId')}"} );
      if (response.statusCode == 200 ) {
        listAllClient=[];
        listNumberFalse=[];
        listClosedCall=[];
        listNoAnswer=[];
        listNotInterested=[];
        listFollowUP=[];
        listDealDone=[];
        listFollowMeeting=[];
        listNotCall=[];
        listFreshLead=[];

        var res=json.decode(response.data);
        //  showToast(text: value.data.toString(), state: ToastState.SUCCESS);
        if(res.length>0){


        //  print(res);
        //  emit(ClientGetSellerSuccessState());
          res.forEach((element){
             if(element['state']=='Fresh Leads') {

              listFreshLead.add(ClientModel.fromJson(element));
            } else if(element['state']=='False Number') {
               listNumberFalse.add(ClientModel.fromJson(element));
             }
            else if(element['state']=='Closed') {
              listClosedCall.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Done Deal') {
              listDealDone.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='No Answer') {
              listNoAnswer.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Not Interested') {
              listNotInterested.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Follow UP') {
              listFollowUP.add(ClientModel.fromJson(element));
            }
            else if(element['state']=='Follow Meeting') {
              listFollowMeeting.add(ClientModel.fromJson(element));
            }
            else if(element['state'].toString().isEmpty){
              listNotCall.add(ClientModel.fromJson(element));
            }
            if(element['dateAlarm'].isNotEmpty && !(DateTime.now().isAfter(DateTime.parse(element['dateAlarm'])))){ NotificationService().scheduleNotification(
               id: element['id'],
                title: '${element['name']} (${element['phone']})',
                body: '${element['note']}',
                payLoad:'+${element['phone']}' ,

                scheduledNotificationDateTime: DateTime.parse(element['dateAlarm']));
              print(element['dateAlarm']);
            }

            listAllClient.add(ClientModel.fromJson(element));
            //myDepartList.add(element['depart']);
          });
          //print(res);
          loadingGet='ok';
          print(listAllClient.length.toString()+"  = lenth");
          emit(ClientGetSellerSuccessState());
          //getMyList();

        }

        print(response.statusCode);

      } else {
        loadingGet='ok';
        emit(ClientGetSellerErrorState());
        messageResult=response.data.toString();
       // print('Get All Data Error: ${response.data}');
      }
    }catch(onError){
      loadingGet='ok';
      messageResult=onError.toString();
      emit(ClientGetSellerErrorState());

      print('Get Client Seller Data Error: ${onError.toString()}');
      print(onError);
    }

  }
  List<Widget>listScreen=[HomeScreen(),NotCallScreen(),InsertClientScreen()];
  List<Widget>listAdminScreen=[HomeScreen(),MonitorScreen(),InsertClientScreen()];

  Future makeCall(String phone) async {
    Uri uri=Uri(scheme: 'tel', path: '${phone}');
    await launchUrl(uri);
 // return  await FlutterPhoneDirectCaller.callNumber(phone);




  }
  int indexSelect=0;
void  indexOfListSelect(index){
  indexSelect=index;
  getEmit();

}
  String dropValue='No Answer';
  List<String>dropValueList=['Closed','False Number','No Answer','Not Interested','Follow UP','Follow Meeting','Done Deal'];

  List<String>dropValueListFresh=['Closed','False Number','No Answer','Not Interested','Follow UP','Follow Meeting','Done Deal','Fresh Leads'];
  void dropButtonChange({vlu}) {
    dropValue = vlu;
    emit(HiringDropState ());
  }
  String sellerId='';
  int getlengthofCalled(){
    return listClosedCall.length+listDealDone.length+listNumberFalse.length+listNoAnswer.length+listNotInterested.length+ listFollowUP.length+listFollowMeeting.length;  }
void getSeller({String date=''}){
listNumberFalse=[];
  listClosedCall=[];
  listNoAnswer=[];
  listNotInterested=[];
  listFollowUP=[];
  listFollowMeeting=[];
  listDealDone=[];
  listNotCall=[];
  listFreshLead=[];
    listAllClient.forEach((element) {
      if(element.seller==sellerId&&date.isNotEmpty&&date==element.dateCall){
       if(element.state=='Closed') {
        listClosedCall.add(element);
      }
       else if(element.state=='Fresh Leads') {
         listFreshLead.add(element);
       }
      else if(element.state=='False Number') {
        listNumberFalse.add(element);
      }
      else if(element.state==' Done Deal') {
        listDealDone.add(element);
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
     }
      else if(element.seller==sellerId&&date.isEmpty){

         if(element.state=='Closed') {
          listClosedCall.add(element);
        }
        else if(element.state=='Done Deal') {
          listDealDone.add(element);
        }
         else if(element.state=='False Number') {
           listNumberFalse.add(element);
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
        }
      if(element.seller==sellerId){
      if(element.state!.isEmpty) {
        listNotCall.add(element);
      }
      }

    });
    getEmit();
}
List<ClientModel>listOfSearch=[];
Future<void> whatsApp(num) async {
    Uri uri1= Uri.parse('whatsapp://send?phone=$num&&text=');
    Uri uri2= Uri.parse("https://wa.me/$num?text=${Uri.parse('')}");
 // Uri uri1= Uri.parse('https://api.whatsapp.com/send?phone=$num&&text=');
//  Uri uri2= Uri.parse("https://wa.me/$num/?text=${Uri.parse('')}");
    if (await canLaunchUrl(uri1)) {
      await launchUrl(uri1);
    } else if(await canLaunchUrl(uri2)) {
      await launchUrl(uri2);
     // showToast(text: 'NO WhatsApp install in this dvice ', state: ToastState.ERROR);
    }else{
      showToast(text: 'NO WhatsApp install in this dvice ', state: ToastState.ERROR);
    }
}
  void search(String value,List<ClientModel> list){
    listOfSearch=[];
    listOfSearch = list.where((element) => element.phone!.toLowerCase().trim().contains(value.toLowerCase())).toList();
    // else  listOfSearch = Share.listofmapFMM.where((element) => element['code']!.toLowerCase().trim().contains(value.toLowerCase())).toList();

     emit(SearchState());
  }
  Future registerSql(code,name,password) async {
  emit(RegisterSQLLoadingState());
    try{
      Response response=await DioHelper.dio.post('register.php',queryParameters: {
        'name': name,
        'code': code,
        'depart': 'GreenGate',
        'password':password,
        'controller': 'false',
        'normal':'0',
        'sudden':'0',
        'location':''
      });
      if(response.statusCode==200){
        await getSellerByDepartSql();
       // loginSql(code, password);
        // print(i);
        //  valuepross=(i+1)/paySlipList.length*100;
        //getEmit();
        print("###############################");
        emit(RegisterSQLSuccessState());
      }
    }catch(error){
      print("payupload "+error.toString());

    }

  }
  Future changePasswordSql(String username, String password,context) async {

    try{
      Response response=await  DioHelper.dio.post('updatepassword.php',queryParameters:{'code': username, 'password': password,} );
      if (response.statusCode == 200 && response.data.trim().contains("success" )) {


        await CacheHelper.putData(key: 'password', value: password);
        Navigator.pop(context);
        emit(ChangePasswordSuccessState());
        // print(value.headers);
        print(response.data.trim()); // The response from PHP script
      } else {
        showToast(text: 'code error', state: ToastState.ERROR);
        print('Login failed: ${response.data.trim()}');

      }}catch(error){
      print(error.toString());
      showToast(text: error.toString(), state: ToastState.ERROR);
    }

  }
  Future updateUserSql(String code, String name,context) async {

    try{
      Response response=await  DioHelper.dio.post('updateUser.php',queryParameters:{'code': code, 'name':name,} );
      if (response.statusCode == 200 && response.data.trim().contains("success" )) {

       getSellerByDepartSql();
       // await CacheHelper.putData(key: 'password', value: password);
        Navigator.pop(context);
        emit(UpdateUseSuccessState());
        // print(value.headers);
        print(response.data.trim()); // The response from PHP script
      } else {
        showToast(text: 'Update error', state: ToastState.ERROR);
        print('Update failed: ${response.data.trim()}');

      }}catch(error){
      print(error.toString());
      showToast(text: error.toString(), state: ToastState.ERROR);
    }

  }
  List<Map<String,dynamic>> listOfMapSeller=[];

  Future getSellerByDepartSql()  async {
    listOfMapSeller=[];

      emit(GetSellerDepartLoadingState());
      // var url = Uri.parse('https://sjiappeg.sji-eg.com/login.php');// Replace with your PHP script URL
      try {
        Response response = await DioHelper.dio.post('getclientbydepart.php',);
        if (response.statusCode == 200) {
          var res = json.decode(response.data);
          if (res.length > 0) {
            res.forEach((element){
              listOfMapSeller.add(element);
            });


            emit(GetSellerDepartSuccessState());

              print(listOfMapSeller);
            print(response.statusCode);
          } else {
            emit(GetSellerDepartErrorState(error: " Error  get seller!!!!!!!!! "));

            print('get seller by Depart failed: ${response.data.toString()}');
          }

        }
      } catch (error) {
        emit(GetSellerDepartErrorState(error: "get seller by Depart onError : ${error.toString()}"));

        print('Login onError: ${error.toString()}');
        print(onError);
      }


  }

}