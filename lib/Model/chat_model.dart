/// status : true
/// chattings : [{"id":"1","message":"Hello Admin","message_type":"text","sender_id":"2","sender_type":"user","booking_id":"2","is_read":"1","created_at":"2023-02-13 11:18:06","updated_at":"2023-02-13 11:42:54"},{"id":"2","message":"sdfgsdfgs dfgsdfg","message_type":"text","sender_id":"1","sender_type":"admin","booking_id":"2","is_read":"1","created_at":"2023-02-13 11:33:33","updated_at":"2023-02-13 11:42:54"},{"id":"3","message":"sdfgsdfgs dfgsdfg","message_type":"text","sender_id":"1","sender_type":"admin","booking_id":"2","is_read":"1","created_at":"2023-02-13 11:34:07","updated_at":"2023-02-13 11:42:54"},{"id":"4","message":"asdf asdfasdf","message_type":"text","sender_id":"1","sender_type":"admin","booking_id":"2","is_read":"1","created_at":"2023-02-13 11:34:45","updated_at":"2023-02-13 11:42:54"},{"id":"5","message":" HEllo wAdmin","message_type":"text","sender_id":"1","sender_type":"user","booking_id":"2","is_read":"0","created_at":"2023-02-13 11:45:27","updated_at":"2023-02-13 11:46:48"},{"id":"6","message":"test","message_type":"text","sender_id":"1","sender_type":"admin","booking_id":"2","is_read":"0","created_at":"2023-02-13 11:45:40","updated_at":"2023-02-13 11:45:40"},{"id":"7","message":"","message_type":"text","sender_id":"1","sender_type":"admin","booking_id":"2","is_read":"0","created_at":"2023-02-13 11:57:37","updated_at":"2023-02-13 11:57:37"},{"id":"8","message":"asda","message_type":"text","sender_id":"1","sender_type":"admin","booking_id":"2","is_read":"0","created_at":"2023-02-13 11:57:47","updated_at":"2023-02-13 11:57:47"},{"id":"9","message":"","message_type":"text","sender_id":"1","sender_type":"admin","booking_id":"2","is_read":"0","created_at":"2023-02-13 11:57:51","updated_at":"2023-02-13 11:57:51"},{"id":"10","message":"63ea265307bc5.png","message_type":"image","sender_id":"1","sender_type":"admin","booking_id":"2","is_read":"0","created_at":"2023-02-13 12:00:19","updated_at":"2023-02-13 12:00:19"}]

class ChatModel {
  ChatModel({
      bool? status, 
      List<Chattings>? chattings,}){
    _status = status;
    _chattings = chattings;
}

  ChatModel.fromJson(dynamic json) {
    _status = json['status'];
    if (json['chattings'] != null) {
      _chattings = [];
      json['chattings'].forEach((v) {
        _chattings?.add(Chattings.fromJson(v));
      });
    }
  }
  bool? _status;
  List<Chattings>? _chattings;
ChatModel copyWith({  bool? status,
  List<Chattings>? chattings,
}) => ChatModel(  status: status ?? _status,
  chattings: chattings ?? _chattings,
);
  bool? get status => _status;
  List<Chattings>? get chattings => _chattings;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_chattings != null) {
      map['chattings'] = _chattings?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// message : "Hello Admin"
/// message_type : "text"
/// sender_id : "2"
/// sender_type : "user"
/// booking_id : "2"
/// is_read : "1"
/// created_at : "2023-02-13 11:18:06"
/// updated_at : "2023-02-13 11:42:54"

class Chattings {
  Chattings({
      String? id, 
      String? message, 
      String? messageType, 
      String? senderId, 
      String? senderType, 
      String? bookingId, 
      String? isRead, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _message = message;
    _messageType = messageType;
    _senderId = senderId;
    _senderType = senderType;
    _bookingId = bookingId;
    _isRead = isRead;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Chattings.fromJson(dynamic json) {
    _id = json['id'];
    _message = json['message'];
    _messageType = json['message_type'];
    _senderId = json['sender_id'];
    _senderType = json['sender_type'];
    _bookingId = json['booking_id'];
    _isRead = json['is_read'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _id;
  String? _message;
  String? _messageType;
  String? _senderId;
  String? _senderType;
  String? _bookingId;
  String? _isRead;
  String? _createdAt;
  String? _updatedAt;
Chattings copyWith({  String? id,
  String? message,
  String? messageType,
  String? senderId,
  String? senderType,
  String? bookingId,
  String? isRead,
  String? createdAt,
  String? updatedAt,
}) => Chattings(  id: id ?? _id,
  message: message ?? _message,
  messageType: messageType ?? _messageType,
  senderId: senderId ?? _senderId,
  senderType: senderType ?? _senderType,
  bookingId: bookingId ?? _bookingId,
  isRead: isRead ?? _isRead,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get message => _message;
  String? get messageType => _messageType;
  String? get senderId => _senderId;
  String? get senderType => _senderType;
  String? get bookingId => _bookingId;
  String? get isRead => _isRead;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['message'] = _message;
    map['message_type'] = _messageType;
    map['sender_id'] = _senderId;
    map['sender_type'] = _senderType;
    map['booking_id'] = _bookingId;
    map['is_read'] = _isRead;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}