class ClientModel{



  String ?seller;
  String ? name;
  String ?date;
  String ?dateCall;
  String ?dateAlarm;
  //String?depart;
  String ?phone;
  String ?note;
  String ?state;
  int ?id;



  ClientModel({this.name, this.phone, this.seller='', this.note='', this.date, this.state='',this.dateCall='',this.dateAlarm=""});

  ClientModel.fromJson(Map<String,dynamic>  json){

    name=json['name'];

    phone=json['phone'];
    dateCall=json['dateCall'];
    dateAlarm=json['dateAlarm'];
    date=json['date'];
    //depart=json['depart'];
    seller=json['seller'];
    note=json['note'];

    state=json['state'];
    id=json['id'];

  }
  Map<String,dynamic> toMap(){
    return {

      "note": note,

      "phone":phone,

      "name":"$name",
      "dateAlarm":dateAlarm,

      "dateCall":dateCall,
      "date":date,
      "seller":seller,
      'state':state,

    };

  }


}