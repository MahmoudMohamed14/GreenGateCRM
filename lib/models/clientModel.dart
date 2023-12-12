class ClientModel{



  String ?seller;
  String ? name;
  String ?date;
  //String?depart;
  String ?phone;
  String ?note;
  String ?state;
  int ?id;



  ClientModel(
      {this.name, this.phone, this.seller='', this.note='', this.date, this.state='',

      });

  ClientModel.fromJson(Map<String,dynamic>  json){

    name=json['name'];

    phone=json['phone'];
    // line=json['line'];
    //  operator=json['operator'];
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

      //"depart":depart,
      "date":date,
      "seller":seller,
      'state':state,

    };

  }


}