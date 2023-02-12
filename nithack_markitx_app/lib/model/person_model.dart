class PersonModel {
  int? id;
  String? name;
  int? age;
  String? gender;
  String? state;
  int? phoneNumber;
  String? email;
  String? ipAddress;
  int? cluster;
  Coordinates? coordinates;

  PersonModel(
      {this.id,
      this.name,
      this.age,
      this.gender,
      this.state,
      this.phoneNumber,
      this.email,
      this.ipAddress,
      this.cluster,
      this.coordinates});

  PersonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    state = json['state'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    ipAddress = json['ip_address'];
    cluster = json['cluster'];
    coordinates = json['coordinates'] != null
        ? new Coordinates.fromJson(json['coordinates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['state'] = this.state;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['ip_address'] = this.ipAddress;
    data['cluster'] = this.cluster;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates!.toJson();
    }
    return data;
  }
}

class Coordinates {
  double? x;
  double? y;

  Coordinates({this.x, this.y});

  Coordinates.fromJson(Map<String, dynamic> json) {
    x = json['x']+0.0;
    y = json['y']+0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}