import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task_model.dart';
import '../models/submission_model.dart';
import '../models/active_task_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();

  final _firestoreService = FirestoreService.to;

  final tasks = <TaskModel>[].obs;
  final submissions = <SubmissionModel>[].obs;
  final activeTasks = <ActiveTaskModel>[].obs;
  final isLoading = false.obs;

  // Selected Category filter
  final selectedCategory = 'All Tasks'.obs;

  @override
  void onInit() {
    super.onInit();
    // Refresh feed whenever user changes
    AuthService.to.currentUser.listen((_) {
      fetchTasksAndSubmissions();
    });
    fetchTasksAndSubmissions();
  }

  Future<void> fetchTasksAndSubmissions() async {
    isLoading.value = true;
    try {
      final loadedTasks = await _firestoreService.getTasks();
      tasks.assignAll(loadedTasks);

      final loadedSubmissions = await _firestoreService.getSubmissions();
      submissions.assignAll(loadedSubmissions);

      final user = AuthService.to.currentUser.value;
      if (user != null) {
        final loadedActiveTasks = await _firestoreService.getActiveTasks(user.email);
        activeTasks.assignAll(loadedActiveTasks);
      } else {
        activeTasks.clear();
      }
    } catch (e) {
      Get.log("Error fetching tasks/submissions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Filter tasks based on selected category
  List<TaskModel> get filteredTasks {
    if (selectedCategory.value == 'All Tasks') {
      return tasks;
    }
    return tasks.where((t) => t.category.toLowerCase() == selectedCategory.value.toLowerCase()).toList();
  }

  // Create a new task (Admin action)
  Future<void> createNewTask({
    required String title,
    required String description,
    required String category,
    required String deadline,
    required int points,
    required String location,
  }) async {
    isLoading.value = true;
    try {
      final id = 'task-${tasks.length + 1}';
      final newTask = TaskModel(
        id: id,
        title: title,
        description: description,
        category: category,
        deadlineText: deadline,
        location: location,
        volunteersCount: 0,
        points: points,
        peopleEmpowered: 0,
        extendedDescription: description,
        instructions: ["Report to distribution point.", "Perform tasks according to standard safety manuals.", "Submit activity logs."],
        resources: [],
      );

      await _firestoreService.createTask(newTask);
      await fetchTasksAndSubmissions();
      Get.snackbar(
        'Success',
        'New task created successfully!',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not create task: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Accept task and add to volunteer active task list
  Future<void> acceptTask(TaskModel task) async {
    final user = AuthService.to.currentUser.value;
    if (user == null) {
      Get.snackbar('Auth Required', 'Please log in to accept tasks.');
      return;
    }

    isLoading.value = true;
    try {
      final newActiveTask = ActiveTaskModel(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        userEmail: user.email,
        title: task.title,
        description: task.description,
        dueText: task.deadline,
        status: 'pending',
        type: 'report',
      );
      await _firestoreService.addActiveTask(newActiveTask);
      await fetchTasksAndSubmissions();
      Get.snackbar(
        'Task Accepted',
        'Task "${task.title}" added to your active tasks list!',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept task: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Submit volunteer report
  Future<void> submitVolunteerReport({
    required String taskId,
    required String taskTitle,
    required String description,
  }) async {
    if (description.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a summary of your work.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final user = AuthService.to.currentUser.value;
      if (user == null) {
        throw Exception("You must be logged in to submit a report.");
      }

      final submission = SubmissionModel(
        id: 'sub-${DateTime.now().millisecondsSinceEpoch}',
        volunteerName: user.name,
        avatarUrl: user.avatarUrl,
        level: user.level,
        taskTitle: taskTitle,
        timeAgo: 'Just now',
        description: description.trim(),
      );

      await _firestoreService.submitReport(submission);
      
      // Clean up from user's active tasks
      // Find if this task title matches one of the user's active tasks
      final active = activeTasks.firstWhereOrNull((t) => t.title == taskTitle || t.id == taskId);
      if (active != null) {
        await _firestoreService.removeActiveTask(active.id, user.email);
      }

      await fetchTasksAndSubmissions();
      await AuthService.to.refreshProfile();

      Get.snackbar(
        'Submitted',
        'Report submitted for review successfully!',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Submission Failed',
        e.toString().replaceAll('Exception:', '').trim(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Admin approves/rejects volunteer work submission
  Future<void> reviewSubmission(String submissionId, String status) async {
    isLoading.value = true;
    try {
      await _firestoreService.reviewSubmission(submissionId, status);
      await fetchTasksAndSubmissions();
      await AuthService.to.refreshProfile();

      Get.snackbar(
        'Status Updated',
        'Submission has been ${status.capitalizeFirst}.',
        backgroundColor: status == 'approved' ? AppColors.primary : AppColors.error,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Review Failed',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
