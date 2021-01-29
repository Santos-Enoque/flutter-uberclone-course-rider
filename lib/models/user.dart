class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const PHOTO = "photo";
  static const PHONE = "phoneNumber";


  String id;
  String name;
  String email;
  String photo;
  String phoneNumber;


  UserModel.fromMap(Map<String, dynamic> data) {
    name = data[NAME];
    photo = data[PHOTO] ?? "";
    phoneNumber = data[PHONE] ?? "";
    id = data[ID];
    email = data[EMAIL];
  }

}
