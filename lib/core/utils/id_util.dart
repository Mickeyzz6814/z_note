import 'dart:math';

class IdUtil {
  static String createId() {
    String dateId = DateTime.now().millisecondsSinceEpoch.toString();
    String numberId = Random().nextInt(10000).toString().padLeft(4, '0');
    String uniqueId = '$dateId$numberId';
    return uniqueId;
  }
}
