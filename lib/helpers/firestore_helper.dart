import 'package:budgetor/constants/strings.dart';
import 'package:budgetor/main.dart';
import 'package:budgetor/models/income.dart';
import 'package:budgetor/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum DataFetchState { hasData, hasNoData, failed }

class FirestoreHelper {
  FirestoreHelper._();

  static final db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<bool> addNewUser(UserModel userModel) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('userId cannot be null when adding new user to firestore');
      DocumentReference docRef = db.collection(usersCollName).doc(userId);
      await docRef.set(userModel.toMap());
      logger.i('DocumentSnapshot added with ID: ${docRef.id}');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<UserModel?> getUserDocData() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('userId cannot be null when fetching user data from firestore');
      DocumentReference docRef = db.collection(usersCollName).doc(userId);
      DocumentSnapshot docSnapshot = await docRef.get();
      Object? docData = docSnapshot.data();
      if (docData == null) return null;
      UserModel userModel = UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      return userModel;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  static Future<DataFetchState> getUserIncomesData() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('userId cannot be null inside getUserIncomesData function');
      DocumentReference docRef = db.collection(usersCollName).doc(userId);
      QuerySnapshot querySnapshot = await docRef.collection(incomesCollName).get();
      List<Income> incomesData = querySnapshot.docs
          .map(
            (doc) => Income.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
      logger.i('incomesData: ${incomesData}');
      if (incomesData.isEmpty) return DataFetchState.hasNoData;
      // Boxes.incomesBox.putMany(incomesData);
      logger.i('returning hasData....');
      return DataFetchState.hasData;
    } catch (e) {
      return DataFetchState.failed;
    }
  }
}
