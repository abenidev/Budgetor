import 'package:budgetor/main.dart';
import 'package:budgetor/models/budget.dart';
import 'package:budgetor/models/income.dart';
import 'package:budgetor/models/savings_goal.dart';
import 'package:budgetor/models/transation.dart';
import 'package:budgetor/models/user_account.dart';
import 'package:budgetor/models/user_model.dart';
import 'package:budgetor/objectbox.g.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "user-data"));
    return ObjectBox._create(store);
  }
}

class Boxes {
  Boxes._();

  static final userBox = objectbox.store.box<UserModel>();
  static final incomesBox = objectbox.store.box<Income>();
  static final budgetBox = objectbox.store.box<Budget>();
  static final categoryBox = objectbox.store.box<Category>();
  static final savingsGoalBox = objectbox.store.box<SavingsGoal>();
  static final transactionBox = objectbox.store.box<Transaction>();
  static final userAccountBox = objectbox.store.box<UserAccount>();
}
