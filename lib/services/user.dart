import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubercourserider/helpers/constants.dart';
import 'package:ubercourserider/models/user.dart';

class UserServices {
  String collection = "users";

  void createUser({
    String id,
    String name,
    String photo,
    String email,

  }) {
    firebaseFirestore
        .collection(collection)
        .doc(id)
        .set({"name": name, "id": id, "photo": photo, "email": email});
  }

  bool updateUserData(Map<String, dynamic> values){
    try{
      firebaseFirestore.collection(collection).doc(values['id']).update(values);

      return true;
    }catch(e){
      logger.e(
          "error updating user data",
          e.toString()
      );
      return false;
    }
  }

  Future<UserModel> getUserById(String id) =>
      firebaseFirestore.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromMap(doc.data());
      });

  Future<bool> doesUserExist(String id) async => firebaseFirestore
      .collection(collection)
      .doc(id)
      .get()
      .then((value) => value.exists);

  Future<List<UserModel>> getAll() async =>
      firebaseFirestore.collection(collection).get().then((result) {
        List<UserModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          users.add(UserModel.fromMap(user.data()));
        }
        return users;
      });
}
