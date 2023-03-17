/// status : true
/// message : "Assignment lists"
/// Assignments : [{"id":"2","mobile":"7896543222","device_token":null,"title":null,"description":"This is my assignment please look into it","document":["https://developmentalphawizz.com/assignment-portal/uploads/assignment/Customizations_forming_part_of_project_proposal2.pdf","https://developmentalphawizz.com/assignment-portal/uploads/assignment/Group_720122.png"],"status":"4","end_date":"2023-02-27","time":"00:00:00","per_page_amount":"0.00","pages":"1","refrence_pages":"0","assigned_to":"3","type":"1","timezone":null,"created_at":"2023-02-08 12:45:58","updated_at":"2023-02-14 07:52:07","uploaded_date":null,"amount_per_page":"0.00","total_amount":"0.00","advance_amount":"0.00","manager_id":null,"referral_code":null,"quotation":{"id":"1","assignment_id":"2","shared_by":"2","is_show_to_user":"1","status":"2","amount":"1000.00","update_amount":"0.00","payment_status":"1","description":null,"created_at":"2023-02-13 05:18:59","updated_at":"2023-02-14 11:00:05","assignment_file":"1676372405dummy-pdf_2_2.pdf","per_page_amount":"0","pages":"0","refrence_pages":"0"}},null]

class AssignmentListModel {
  AssignmentListModel({
      bool? status, 
      String? message, 
      List<Assignments>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  AssignmentListModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Assignments.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Assignments>? _data;
AssignmentListModel copyWith({  bool? status,
  String? message,
  List<Assignments>? data,
}) => AssignmentListModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<Assignments>? get data => _data;

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

/// id : "2"
/// mobile : "7896543222"
/// device_token : null
/// title : null
/// description : "This is my assignment please look into it"
/// document : ["https://developmentalphawizz.com/assignment-portal/uploads/assignment/Customizations_forming_part_of_project_proposal2.pdf","https://developmentalphawizz.com/assignment-portal/uploads/assignment/Group_720122.png"]
/// status : "4"
/// end_date : "2023-02-27"
/// time : "00:00:00"
/// per_page_amount : "0.00"
/// pages : "1"
/// refrence_pages : "0"
/// assigned_to : "3"
/// type : "1"
/// timezone : null
/// created_at : "2023-02-08 12:45:58"
/// updated_at : "2023-02-14 07:52:07"
/// uploaded_date : null
/// amount_per_page : "0.00"
/// total_amount : "0.00"
/// advance_amount : "0.00"
/// manager_id : null
/// referral_code : null
/// quotation : {"id":"1","assignment_id":"2","shared_by":"2","is_show_to_user":"1","status":"2","amount":"1000.00","update_amount":"0.00","payment_status":"1","description":null,"created_at":"2023-02-13 05:18:59","updated_at":"2023-02-14 11:00:05","assignment_file":"1676372405dummy-pdf_2_2.pdf","per_page_amount":"0","pages":"0","refrence_pages":"0"}

class Assignments {
  Assignments({
      String? id, 
      String? mobile, 
      dynamic deviceToken, 
      dynamic title, 
      String? description, 
      List<String>? document, 
      String? status, 
      String? endDate, 
      String? time, 
      String? perPageAmount, 
      String? pages, 
      String? refrencePages, 
      String? assignedTo, 
      String? type, 
      dynamic timezone, 
      String? createdAt, 
      String? updatedAt, 
      dynamic uploadedDate, 
      String? amountPerPage, 
      String? totalAmount, 
      String? advanceAmount, 
      dynamic managerId, 
      dynamic referralCode, 
      Quotation? quotation,}){
    _id = id;
    _mobile = mobile;
    _deviceToken = deviceToken;
    _title = title;
    _description = description;
    _document = document;
    _status = status;
    _endDate = endDate;
    _time = time;
    _perPageAmount = perPageAmount;
    _pages = pages;
    _refrencePages = refrencePages;
    _assignedTo = assignedTo;
    _type = type;
    _timezone = timezone;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _uploadedDate = uploadedDate;
    _amountPerPage = amountPerPage;
    _totalAmount = totalAmount;
    _advanceAmount = advanceAmount;
    _managerId = managerId;
    _referralCode = referralCode;
    _quotation = quotation;
}

  Assignments.fromJson(dynamic json) {
    _id = json['id'];
    _mobile = json['mobile'];
    _deviceToken = json['device_token'];
    _title = json['title'];
    _description = json['description'];
    _document = json['document'] != null ? json['document'].cast<String>() : [];
    _status = json['status'];
    _endDate = json['end_date'];
    _time = json['time'];
    _perPageAmount = json['per_page_amount'];
    _pages = json['pages'];
    _refrencePages = json['refrence_pages'];
    _assignedTo = json['assigned_to'];
    _type = json['type'];
    _timezone = json['timezone'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _uploadedDate = json['uploaded_date'];
    _amountPerPage = json['amount_per_page'];
    _totalAmount = json['total_amount'];
    _advanceAmount = json['advance_amount'];
    _managerId = json['manager_id'];
    _referralCode = json['referral_code'];
    _quotation = json['quotation'] != '' ? Quotation.fromJson(json['quotation']) : null;
  }
  String? _id;
  String? _mobile;
  dynamic _deviceToken;
  dynamic _title;
  String? _description;
  List<String>? _document;
  String? _status;
  String? _endDate;
  String? _time;
  String? _perPageAmount;
  String? _pages;
  String? _refrencePages;
  String? _assignedTo;
  String? _type;
  dynamic _timezone;
  String? _createdAt;
  String? _updatedAt;
  dynamic _uploadedDate;
  String? _amountPerPage;
  String? _totalAmount;
  String? _advanceAmount;
  dynamic _managerId;
  dynamic _referralCode;
  Quotation? _quotation;
Assignments copyWith({  String? id,
  String? mobile,
  dynamic deviceToken,
  dynamic title,
  String? description,
  List<String>? document,
  String? status,
  String? endDate,
  String? time,
  String? perPageAmount,
  String? pages,
  String? refrencePages,
  String? assignedTo,
  String? type,
  dynamic timezone,
  String? createdAt,
  String? updatedAt,
  dynamic uploadedDate,
  String? amountPerPage,
  String? totalAmount,
  String? advanceAmount,
  dynamic managerId,
  dynamic referralCode,
  Quotation? quotation,
}) => Assignments(  id: id ?? _id,
  mobile: mobile ?? _mobile,
  deviceToken: deviceToken ?? _deviceToken,
  title: title ?? _title,
  description: description ?? _description,
  document: document ?? _document,
  status: status ?? _status,
  endDate: endDate ?? _endDate,
  time: time ?? _time,
  perPageAmount: perPageAmount ?? _perPageAmount,
  pages: pages ?? _pages,
  refrencePages: refrencePages ?? _refrencePages,
  assignedTo: assignedTo ?? _assignedTo,
  type: type ?? _type,
  timezone: timezone ?? _timezone,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  uploadedDate: uploadedDate ?? _uploadedDate,
  amountPerPage: amountPerPage ?? _amountPerPage,
  totalAmount: totalAmount ?? _totalAmount,
  advanceAmount: advanceAmount ?? _advanceAmount,
  managerId: managerId ?? _managerId,
  referralCode: referralCode ?? _referralCode,
  quotation: quotation ?? _quotation,
);
  String? get id => _id;
  String? get mobile => _mobile;
  dynamic get deviceToken => _deviceToken;
  dynamic get title => _title;
  String? get description => _description;
  List<String>? get document => _document;
  String? get status => _status;
  String? get endDate => _endDate;
  String? get time => _time;
  String? get perPageAmount => _perPageAmount;
  String? get pages => _pages;
  String? get refrencePages => _refrencePages;
  String? get assignedTo => _assignedTo;
  String? get type => _type;
  dynamic get timezone => _timezone;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get uploadedDate => _uploadedDate;
  String? get amountPerPage => _amountPerPage;
  String? get totalAmount => _totalAmount;
  String? get advanceAmount => _advanceAmount;
  dynamic get managerId => _managerId;
  dynamic get referralCode => _referralCode;
  Quotation? get quotation => _quotation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['mobile'] = _mobile;
    map['device_token'] = _deviceToken;
    map['title'] = _title;
    map['description'] = _description;
    map['document'] = _document;
    map['status'] = _status;
    map['end_date'] = _endDate;
    map['time'] = _time;
    map['per_page_amount'] = _perPageAmount;
    map['pages'] = _pages;
    map['refrence_pages'] = _refrencePages;
    map['assigned_to'] = _assignedTo;
    map['type'] = _type;
    map['timezone'] = _timezone;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['uploaded_date'] = _uploadedDate;
    map['amount_per_page'] = _amountPerPage;
    map['total_amount'] = _totalAmount;
    map['advance_amount'] = _advanceAmount;
    map['manager_id'] = _managerId;
    map['referral_code'] = _referralCode;
    if (_quotation != null) {
      map['quotation'] = _quotation?.toJson();
    }
    return map;
  }

}

/// id : "1"
/// assignment_id : "2"
/// shared_by : "2"
/// is_show_to_user : "1"
/// status : "2"
/// amount : "1000.00"
/// update_amount : "0.00"
/// payment_status : "1"
/// description : null
/// created_at : "2023-02-13 05:18:59"
/// updated_at : "2023-02-14 11:00:05"
/// assignment_file : "1676372405dummy-pdf_2_2.pdf"
/// per_page_amount : "0"
/// pages : "0"
/// refrence_pages : "0"

class Quotation {
  Quotation({
      String? id, 
      String? assignmentId, 
      String? sharedBy, 
      String? isShowToUser, 
      String? status, 
      String? amount, 
      String? updateAmount, 
      String? paymentStatus, 
      dynamic description, 
      String? createdAt, 
      String? updatedAt, 
      String? assignmentFile, 
      String? perPageAmount, 
      String? pages, 
      String? refrencePages,}){
    _id = id;
    _assignmentId = assignmentId;
    _sharedBy = sharedBy;
    _isShowToUser = isShowToUser;
    _status = status;
    _amount = amount;
    _updateAmount = updateAmount;
    _paymentStatus = paymentStatus;
    _description = description;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _assignmentFile = assignmentFile;
    _perPageAmount = perPageAmount;
    _pages = pages;
    _refrencePages = refrencePages;
}

  Quotation.fromJson(dynamic json) {
    _id = json['id'];
    _assignmentId = json['assignment_id'];
    _sharedBy = json['shared_by'];
    _isShowToUser = json['is_show_to_user'];
    _status = json['status'];
    _amount = json['amount'];
    _updateAmount = json['update_amount'];
    _paymentStatus = json['payment_status'];
    _description = json['description'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _assignmentFile = json['assignment_file'];
    _perPageAmount = json['per_page_amount'];
    _pages = json['pages'];
    _refrencePages = json['refrence_pages'];
  }
  String? _id;
  String? _assignmentId;
  String? _sharedBy;
  String? _isShowToUser;
  String? _status;
  String? _amount;
  String? _updateAmount;
  String? _paymentStatus;
  dynamic _description;
  String? _createdAt;
  String? _updatedAt;
  String? _assignmentFile;
  String? _perPageAmount;
  String? _pages;
  String? _refrencePages;
Quotation copyWith({  String? id,
  String? assignmentId,
  String? sharedBy,
  String? isShowToUser,
  String? status,
  String? amount,
  String? updateAmount,
  String? paymentStatus,
  dynamic description,
  String? createdAt,
  String? updatedAt,
  String? assignmentFile,
  String? perPageAmount,
  String? pages,
  String? refrencePages,
}) => Quotation(  id: id ?? _id,
  assignmentId: assignmentId ?? _assignmentId,
  sharedBy: sharedBy ?? _sharedBy,
  isShowToUser: isShowToUser ?? _isShowToUser,
  status: status ?? _status,
  amount: amount ?? _amount,
  updateAmount: updateAmount ?? _updateAmount,
  paymentStatus: paymentStatus ?? _paymentStatus,
  description: description ?? _description,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  assignmentFile: assignmentFile ?? _assignmentFile,
  perPageAmount: perPageAmount ?? _perPageAmount,
  pages: pages ?? _pages,
  refrencePages: refrencePages ?? _refrencePages,
);
  String? get id => _id;
  String? get assignmentId => _assignmentId;
  String? get sharedBy => _sharedBy;
  String? get isShowToUser => _isShowToUser;
  String? get status => _status;
  String? get amount => _amount;
  String? get updateAmount => _updateAmount;
  String? get paymentStatus => _paymentStatus;
  dynamic get description => _description;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get assignmentFile => _assignmentFile;
  String? get perPageAmount => _perPageAmount;
  String? get pages => _pages;
  String? get refrencePages => _refrencePages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['assignment_id'] = _assignmentId;
    map['shared_by'] = _sharedBy;
    map['is_show_to_user'] = _isShowToUser;
    map['status'] = _status;
    map['amount'] = _amount;
    map['update_amount'] = _updateAmount;
    map['payment_status'] = _paymentStatus;
    map['description'] = _description;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['assignment_file'] = _assignmentFile;
    map['per_page_amount'] = _perPageAmount;
    map['pages'] = _pages;
    map['refrence_pages'] = _refrencePages;
    return map;
  }

}