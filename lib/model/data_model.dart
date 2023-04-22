class DataModel {
  String ?userName;
  String ?number;


  DataModel({this.userName,  this.number});

  DataModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    number = json['number'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['number'] = this.number;

    return data;
  }
}