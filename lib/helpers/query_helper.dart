import 'package:budgetor/helpers/objectbox_helper.dart';
import 'package:budgetor/models/income.dart';
import 'package:budgetor/models/user_model.dart';
import 'package:budgetor/objectbox.g.dart';

class QueryHelper {
  QueryHelper._();

  static Stream<List<Income>> getUserIncomes() {
    QueryBuilder<Income> builder = Boxes.incomesBox.query().order(Income_.dateAdded, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  static UserModel getUserData() {
    return Boxes.userBox.getAll()[0];
  }

  static Income? getUserIncomeByName(String incomeName) {
    QueryBuilder<Income> builder = Boxes.incomesBox.query(Income_.name.equals(incomeName));
    List<Income> incomesFound = builder.build().find();
    if (incomesFound.isEmpty) return null;
    return incomesFound[0];
  }
}
