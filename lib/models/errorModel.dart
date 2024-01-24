class ErrorModel{


String? phone;
  String ?message;
  int ?id;



ErrorModel({this.id,this.message,this.phone});

ErrorModel.fromJson(Map<String,dynamic>  json){
    message=json['message'];
    id=json['id'];
    phone=json['phone'];


  }
  Map<String,dynamic> toMap(){
    return {

      "message": message,
      "phone":phone,
      "id":id
    };

  }


}