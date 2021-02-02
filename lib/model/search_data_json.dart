class SearchResultDataGS {
  int status;
  String message;
  int code;
  List<SearchResultDataResponse> response;

  SearchResultDataGS({this.status, this.message, this.code, this.response});

  SearchResultDataGS.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    code = json['code'];
    if (json['response'] != null) {
      response = new List<SearchResultDataResponse>();
      json['response'].forEach((v) {
        response.add(new SearchResultDataResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchResultDataResponse {
  int id;
  int is_round_trip;
  String uuid;
  int userId;
  int routeId;
  int taxiTypeId;
  String availableDate;
  String availableTime;
  String postActiveTill;
  int fare;
  int commision;
  int isActive;
  int feed_contacted;
  Null deletedAt;
  String createdAt;
  String updatedAt;
  String taxiTypeName;
  String origin;
  String destination;
  String mobile;
  String hour;
  String minute;
  int own_booking;
  int origin_id;
  int destination_id;
  String post_active_till;

  SearchResultDataResponse(
      {this.id,
        this.uuid,
        this.userId,
        this.routeId,
        this.taxiTypeId,
        this.availableDate,
        this.availableTime,
        this.postActiveTill,
        this.fare,
        this.commision,
        this.isActive,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.taxiTypeName,
        this.origin,
        this.destination,
        this.mobile,
        this.hour,
        this.minute,
        this.own_booking,
        this.origin_id,
        this.destination_id,
        this.post_active_till,
        this.is_round_trip,
        this.feed_contacted});

  SearchResultDataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    routeId = json['route_id'];
    taxiTypeId = json['taxi_type_id'];
    availableDate = json['available_date'];
    availableTime = json['available_time'];
    postActiveTill = json['post_active_till'];
    fare = json['fare'];
    commision = json['commision'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    taxiTypeName = json['taxi_type_name'];
    origin = json['origin'];
    destination = json['destination'];
    mobile = json['mobile'];
    hour = json['hour'];
    minute = json['minute'];
    own_booking = json['own_booking'];
    post_active_till = json['post_active_till'];
    destination_id = json['destination_id'];
    origin_id = json['origin_id'];
    feed_contacted = json['feed_contacted'];
    is_round_trip = json['is_round_trip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['user_id'] = this.userId;
    data['route_id'] = this.routeId;
    data['taxi_type_id'] = this.taxiTypeId;
    data['available_date'] = this.availableDate;
    data['available_time'] = this.availableTime;
    data['post_active_till'] = this.postActiveTill;
    data['fare'] = this.fare;
    data['commision'] = this.commision;
    data['is_active'] = this.isActive;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['taxi_type_name'] = this.taxiTypeName;
    data['origin'] = this.origin;
    data['destination'] = this.destination;
    data['mobile'] = this.mobile;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    data['own_booking'] = this.own_booking;
    data['post_active_till'] = this.post_active_till;
    data['origin_id'] = this.origin_id;
    data['destination_id'] = this.destination_id;
    data['feed_contacted'] = this.feed_contacted;
    data['is_round_trip'] = this.is_round_trip;
    return data;
  }
}

class User {
  int id;
  String uuid;
  String mobile;
  String countryCode;
  int isActive;
  int isVerified;
  int isAdmin;
  Null deletedAt;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
        this.uuid,
        this.mobile,
        this.countryCode,
        this.isActive,
        this.isVerified,
        this.isAdmin,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    isActive = json['is_active'];
    isVerified = json['is_verified'];
    isAdmin = json['is_admin'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['mobile'] = this.mobile;
    data['country_code'] = this.countryCode;
    data['is_active'] = this.isActive;
    data['is_verified'] = this.isVerified;
    data['is_admin'] = this.isAdmin;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class VehicleResponse {
  String type;
  int id;

  VehicleResponse({this.type, this.id});

  VehicleResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}