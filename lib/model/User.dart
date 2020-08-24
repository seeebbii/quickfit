class User{
  String id,
      name,
      email,
      phone,
      image_url,
      is_phone_verified,
      status;


  User(this.id, this.name, this.email, this.phone, this.image_url,
      this.is_phone_verified, this.status);

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image_url = json['image'];
    is_phone_verified  = json['is_phone_verified'];
    status = json['status'];
  }

}