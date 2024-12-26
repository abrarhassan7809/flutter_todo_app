import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';


/// All Crud Operation here for Hive Database
class HiveDataStore {
  static const boxName = 'taskBox';

  /// Box with all save data inside
  final Box<Task> box = Hive.box<Task>(boxName);

  /// Add new Task
  Future<void> addTask ({required Task task}) async {
    await box.put(task.id, task);
  }

  /// Show Task
  Future<Task?> getTask ({required String id}) async {
    return box.get(id);
  }

  /// Update Task
  Future<void> updateTask ({required Task task}) async {
    await task.save();
  }

  /// Delete Task
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  /// Listen to box changes
  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}