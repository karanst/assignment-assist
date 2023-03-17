/// status : true
/// message : "Banner List"
/// data : [{"id":"1","banners_name":"banner-1","img":"uploads/banner/1img.jpg"},{"id":"2","banners_name":"banner-2","img":"uploads/banner/images (9).jpg"}]

class BannerModel {
  BannerModel({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  BannerModel.fromJson(dynamic json) {
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
BannerModel copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => BannerModel(  status: status ?? _status,
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

/// id : "1"
/// banners_name : "banner-1"
/// img : "uploads/banner/1img.jpg"

class Data {
  Data({
      String? id, 
      String? bannersName, 
      String? img,}){
    _id = id;
    _bannersName = bannersName;
    _img = img;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _bannersName = json['banners_name'];
    _img = json['img'];
  }
  String? _id;
  String? _bannersName;
  String? _img;
Data copyWith({  String? id,
  String? bannersName,
  String? img,
}) => Data(  id: id ?? _id,
  bannersName: bannersName ?? _bannersName,
  img: img ?? _img,
);
  String? get id => _id;
  String? get bannersName => _bannersName;
  String? get img => _img;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['banners_name'] = _bannersName;
    map['img'] = _img;
    return map;
  }

}