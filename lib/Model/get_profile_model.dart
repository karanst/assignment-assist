/// status : true
/// message : "User profile"
/// data : [{"id":"3","name":"Karan S Tomar","email":"karansinghalphawizz@gmail.com","mobile":"8770496665","password":"","status":"0","wallet":"0.00","image":"https://developmentalphawizz.com/assignment-portal/uploads/profile/image_picker7159112453069174177.jpg","device_token":null,"scanner_id":"64144f75466e2","refferal_code":"asfaertwre","created_at":"2023-02-09 05:23:56","updated_at":"2023-03-17 13:32:49"}]

class GetProfileModel {
  GetProfileModel({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  GetProfileModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Data>? _data;
GetProfileModel copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => GetProfileModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "3"
/// name : "Karan S Tomar"
/// email : "karansinghalphawizz@gmail.com"
/// mobile : "8770496665"
/// password : ""
/// status : "0"
/// wallet : "0.00"
/// image : "https://developmentalphawizz.com/assignment-portal/uploads/profile/image_picker7159112453069174177.jpg"
/// device_token : null
/// scanner_id : "64144f75466e2"
/// refferal_code : "asfaertwre"
/// created_at : "2023-02-09 05:23:56"
/// updated_at : "2023-03-17 13:32:49"

class Data {
  Data({
      String? id, 
      String? name, 
      String? email, 
      String? mobile, 
      String? password, 
      String? status, 
      String? wallet, 
      String? image, 
      dynamic deviceToken, 
      String? scannerId, 
      String? refferalCode, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _email = email;
    _mobile = mobile;
    _password = password;
    _status = status;
    _wallet = wallet;
    _image = image;
    _deviceToken = deviceToken;
    _scannerId = scannerId;
    _refferalCode = refferalCode;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _mobile = json['mobile'];
    _password = json['password'];
    _status = json['status'];
    _wallet = json['wallet'];
    _image = json['image'];
    _deviceToken = json['device_token'];
    _scannerId = json['scanner_id'];
    _refferalCode = json['refferal_code'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _id;
  String? _name;
  String? _email;
  String? _mobile;
  String? _password;
  String? _status;
  String? _wallet;
  String? _image;
  dynamic _deviceToken;
  String? _scannerId;
  String? _refferalCode;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  String? id,
  String? name,
  String? email,
  String? mobile,
  String? password,
  String? status,
  String? wallet,
  String? image,
  dynamic deviceToken,
  String? scannerId,
  String? refferalCode,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  mobile: mobile ?? _mobile,
  password: password ?? _password,
  status: status ?? _status,
  wallet: wallet ?? _wallet,
  image: image ?? _image,
  deviceToken: deviceToken ?? _deviceToken,
  scannerId: scannerId ?? _scannerId,
  refferalCode: refferalCode ?? _refferalCode,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get mobile => _mobile;
  String? get password => _password;
  String? get status => _status;
  String? get wallet => _wallet;
  String? get image => _image;
  dynamic get deviceToken => _deviceToken;
  String? get scannerId => _scannerId;
  String? get refferalCode => _refferalCode;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['password'] = _password;
    map['status'] = _status;
    map['wallet'] = _wallet;
    map['image'] = _image;
    map['device_token'] = _deviceToken;
    map['scanner_id'] = _scannerId;
    map['refferal_code'] = _refferalCode;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}