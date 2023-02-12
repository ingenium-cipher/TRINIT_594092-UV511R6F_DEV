class NewUserModel {
  String? name;
  int? phoneNumber;
  String? email;
  String? gender;
  String? state;
  int? age;

  NewUserModel({
    this.name,
    this.age,
    this.gender,
    this.state,
    this.phoneNumber,
    this.email,
  });

  NewUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    state = json['state'];
    phoneNumber = json['phone_number'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['state'] = this.state;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    return data;
  }
}
