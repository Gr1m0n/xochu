class ResponsePointsData {
  List<PointsModel>? data;

  ResponsePointsData({this.data});

  ResponsePointsData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <PointsModel>[];
      json.forEach((v) {
        data!.add(new PointsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class PointsModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;
  Translation? translation;

  PointsModel(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.latitude,
        this.longitude,
        this.translation});

  PointsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.translation != null) {
      data['translation'] = this.translation!.toJson();
    }
    return data;
  }
}

class Translation {
  String? id;
  String? ownerId;
  String? language;
  String? title;
  String? body;
  String? worktime;

  Translation(
      {this.id,
        this.ownerId,
        this.language,
        this.title,
        this.body,
        this.worktime});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    language = json['language'];
    title = json['title'];
    body = json['body'];
    worktime = json['worktime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_id'] = this.ownerId;
    data['language'] = this.language;
    data['title'] = this.title;
    data['body'] = this.body;
    data['worktime'] = this.worktime;
    return data;
  }
}