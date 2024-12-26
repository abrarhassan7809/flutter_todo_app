import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/views/home/components/fab.dart';
import 'package:todo_app/views/home/widget/task_widget.dart';
import '../../models/task.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_str.dart';
import '../../utils/constants.dart';
import 'components/home_app_bar.dart';
import 'components/slider_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

          return Scaffold(
              backgroundColor: Colors.white,

              // FAB
              floatingActionButton: const Fab(),

              // Body
              body: SliderDrawer(
                key: drawerKey,
                isDraggable: false,
                animationDuration: 1000,

                // Drawer
                slider: CustomDrawer(),

                appBar: HomeAppBar(drawerKey: drawerKey,),

                // Main Body
                child: _buildHomeBody(textTheme, base, tasks),
              )
          );
        }
    );
  }

  Widget _buildHomeBody(
      TextTheme textTheme,
      BaseWidget base,
      List<Task> tasks,
      ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Custom App Bar
          Container(
            margin: EdgeInsets.only(top: 40),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.primaryColor,
                    ),
                  ),
                ),

                // Space
                25.w,

                // Top Level Task Info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    3.h,
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} task",
                      style: textTheme.titleMedium,
                    )
                  ],
                )
              ],
            ),
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          // Tasks
          SizedBox(
            width: double.infinity,
            height: 500,
            child: tasks.isNotEmpty
                ? ListView.builder(
              itemCount: tasks.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return Dismissible(
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) {
                    base.dataStore.deleteTask(task: task);
                  },
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete_outlined, color: Colors.grey),
                      8.w,
                      const Text(
                        AppStr.deletedTask,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  key: Key(task.id),
                  child: TaskWidget(task: task),
                );
              },
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeIn(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      lottieURL,
                      animate: tasks.isNotEmpty ? false : true,
                    ),
                  ),
                ),
                FadeInUp(
                  from: 30,
                  child: Text(AppStr.donAllTask),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
