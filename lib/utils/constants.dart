import 'package:flutter/cupertino.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/app_str.dart';

/// lottie assets address
String lottieURL = 'assets/lottie/1.json';

/// empty title or subtitle text field
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: "You must fill all fields!",
    corner: 20.0,
    duration: 2000,
    padding: EdgeInsets.all(20)
  );
}

/// nothing enter when user try to edit or update the current task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
      context,
      msg: AppStr.oopsMsg,
      subMsg: "You must edit the tasks then try to update it!",
      corner: 20.0,
      duration: 5000,
      padding: EdgeInsets.all(20)
  );
}

/// no task warning dialog for deleting
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.show(
    context,
    title: AppStr.oopsMsg,
    message: "There is no task for delete",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

/// delete all task from DB
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message: "Do you really want to delete all tasks?",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapConfirm: () {
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}
