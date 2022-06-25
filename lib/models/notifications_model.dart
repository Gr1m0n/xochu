class ResponseNotificationsData {
  List<NotificationsModel>? data;

  ResponseNotificationsData({this.data});

  ResponseNotificationsData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <NotificationsModel>[];
      json.forEach((v) {
        data!.add(new NotificationsModel.fromJson(v));
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
class NotificationsModel {
  String? id;
  String? userId;
  String? title;
  String? message;
  String? createdAt;

  NotificationsModel(
      {this.id, this.userId, this.title, this.message, this.createdAt});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}