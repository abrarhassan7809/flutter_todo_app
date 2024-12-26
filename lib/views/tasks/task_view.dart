import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/tasks/widget/task_view_app_bar.dart';
import '../../models/task.dart';
import 'components/date_time_selection.dart';
import 'components/rep_textfield.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }

    } else {
      return DateFormat('hh:mm a').format(widget.task!.createdAtTime).toString();
    }
  }

  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }

    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      }else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  bool isTaskAlreadyExist(){
    if(widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    if (widget.titleTaskController?.text != null
        && widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;

        widget.task?.save();
        Navigator.pop(context);
      } catch (e) {
        updateTaskWarning(context);
      }
    } else {
      if (title != null && subTitle != null) {
        var task = Task.create(
          title: title,
          subTitle: subTitle,
          createdAtDate: date,
          createdAtTime: time
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.pop(context);
      } else {
        emptyWarning(context);
      }
    }
  }

  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus,
      child: Scaffold(
        appBar: const TaskViewAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Top side Texts
                _buildTopSideTexts(textTheme),
                /// Main Task View Activity
                _buildMainTaskViewActivity(textTheme, context),
                /// Bottom Side Button
                _buildBottomSideButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSideButtons() {
    return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: isTaskAlreadyExist()
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceEvenly,
                  children: [
                    isTaskAlreadyExist()
                        ? Container()
                        :
                    /// Delete Current Task Button
                    MaterialButton(
                      onPressed: () {
                        deleteTask();
                        Navigator.pop(context);
                      },
                      minWidth: 150,
                      height: 55,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.close,
                            color: AppColors.primaryColor,
                          ),
                          5.w,
                          Text(
                            AppStr.deleteTask,
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    /// Add or Update Task
                    MaterialButton(
                      onPressed: () {
                        isTaskAlreadyExistUpdateOtherWiseCreate();
                      },
                      minWidth: 150,
                      height: 55,
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(
                        isTaskAlreadyExist()
                          ? AppStr.addTaskString
                          : AppStr.updateTaskString,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
                width: double.infinity,
                height: 480,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        AppStr.titleOfTitleTextField,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    RepTextField(
                      controller: widget.titleTaskController ?? TextEditingController(),
                      onFieldSubmitted: (String inputTitle) {
                        title = inputTitle;
                      },
                      onChanged: (String inputTitle) {
                        title = inputTitle;
                      },
                    ),
                    10.h,
                    RepTextField(
                      controller: widget.descriptionTaskController ?? TextEditingController(),
                      isForDescription: true,
                      onFieldSubmitted: (String inputSubTitle) {
                        subTitle = inputSubTitle;
                      },
                      onChanged: (String inputSubTitle) {
                        subTitle = inputSubTitle;
                      },
                    ),
                    DateTimeSelectionWidget(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => SizedBox(
                            height: 280,
                            child: TimePickerWidget(
                              initDateTime: showDateAsDateTime(time),
                              dateFormat: "HH:mm",
                              onChange: (_, __) {},
                              onConfirm: (dateTime, _) {
                                setState(() {
                                  if (widget.task?.createdAtTime == null) {
                                    time = dateTime;
                                  } else {
                                    widget.task!.createdAtTime = dateTime;
                                  }
                                });
                              },
                            ),
                          ),);
                      },
                      title: "Time",
                      isTime: true,
                      time: showTime(time),
                    ),
                    DateTimeSelectionWidget(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          maxDateTime: DateTime(2030, 4, 5),
                          minDateTime: DateTime.now(),
                          initialDateTime: showDateAsDateTime(date),
                          onConfirm: (dateTime, _) {
                            setState(() {
                              if (widget.task?.createdAtDate == null) {
                                date = dateTime;
                              } else {
                                widget.task!.createdAtDate = dateTime;
                              }
                            });
                          }
                        );
                      },
                      title: AppStr.dateString,
                      time: showDate(date),
                    ),
                  ],
                ),
              );
  }

  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 55,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: isTaskAlreadyExist()
                        ? AppStr.addNewTask
                        : AppStr.updateCurrentTask,
                    style: textTheme.titleLarge,
                    children: const [
                      TextSpan(
                        text: AppStr.taskString,
                        style: TextStyle(fontWeight: FontWeight.w400)
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 55,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
              ],
            ),
          );
  }
}
