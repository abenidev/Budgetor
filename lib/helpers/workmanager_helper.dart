import 'package:budgetor/helpers/local_notification_helper.dart';
import 'package:budgetor/main.dart';
import 'package:workmanager/workmanager.dart';

const String taskName = 'taskName';

class WorkmanagerHelper {
  WorkmanagerHelper._();

  static initExecuteTask() {
    Workmanager().executeTask((task, inputData) async {
      if (task == taskName) {
        try {
          await LocalNotificationHelper.initializeNotif();
          LocalNotificationHelper.showSimpleNotif(
            id: 0,
            title: "Background Run",
            body: "This is a run from the background task.",
          );
        } catch (err) {
          logger.e(err.toString());
          throw Exception(err);
        }
      }

      return Future.value(true);
    });
  }

  static registerDemoTask() {
    Workmanager().registerPeriodicTask(
      "periodic-task-identifier",
      taskName,
      // When no frequency is provided the default 15 minutes is set.
      // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
      frequency: const Duration(minutes: 15),
    );
  }
}
