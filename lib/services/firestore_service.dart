import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/submission_model.dart';
import '../models/active_task_model.dart';
import '../models/leaderboard_model.dart';
import 'auth_service.dart';

/// FirestoreService — ALL operations use real Firestore.
/// There are NO local mock fallbacks. Any failure is thrown to the caller.
class FirestoreService extends GetxService {
  static FirestoreService get to => Get.find();

  late final FirebaseFirestore _db;

  // Timeout for all Firestore operations
  static const Duration _timeout = Duration(seconds: 10);

  Future<FirestoreService> init() async {
    _db = FirebaseFirestore.instance;
    Get.log('Firestore initialized successfully.');
    return this;
  }

  // --- DB Operations: User Profiles ---

  Future<UserModel?> getUserProfile(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final doc = await _db
        .collection('users')
        .doc(normalizedEmail)
        .get()
        .timeout(_timeout);
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> saveUserProfile(UserModel user) async {
    final normalizedEmail = user.email.trim().toLowerCase();
    final normalizedUser = user.copyWith(email: normalizedEmail);
    await _db
        .collection('users')
        .doc(normalizedEmail)
        .set(normalizedUser.toJson(), SetOptions(merge: true))
        .timeout(_timeout);
  }

  // --- DB Operations: Leaderboard ---

  Future<List<LeaderboardModel>> getLeaderboard() async {
    final snapshot = await _db
        .collection('users')
        .orderBy('points', descending: true)
        .get()
        .timeout(_timeout);
    int rank = 1;
    final currentEmail = AuthService.to.currentUser.value?.email;

    final List<LeaderboardModel> list = [];
    for (var doc in snapshot.docs) {
      final user = UserModel.fromJson(doc.data());
      String badge = 'Volunteer';
      if (rank == 1) {
        badge = 'Top Performer';
      } else if (rank == 2) {
        badge = 'Impact Ace';
      } else if (rank == 3) {
        badge = 'Resource Genius';
      } else if (user.points > 1000) {
        badge = 'Veteran';
      } else if (user.points > 500) {
        badge = 'Educator';
      }

      list.add(LeaderboardModel(
        name: user.name,
        rank: rank,
        avatarUrl: user.avatarUrl,
        points: user.points,
        badgeText: badge,
        tasksCompleted: user.tasksCompletedCount,
        isYou: user.email == currentEmail,
      ));
      rank++;
    }
    return list;
  }

  // --- DB Operations: Tasks ---

  Future<List<TaskModel>> getTasks() async {
    final snapshot =
        await _db.collection('tasks').get().timeout(_timeout);
    return snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();
  }

  Future<void> createTask(TaskModel task) async {
    await _db
        .collection('tasks')
        .doc(task.id)
        .set(task.toJson())
        .timeout(_timeout);
  }

  // --- DB Operations: Active Tasks ---

  Future<List<ActiveTaskModel>> getActiveTasks(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final snapshot = await _db
        .collection('active_tasks')
        .where('userEmail', isEqualTo: normalizedEmail)
        .get()
        .timeout(_timeout);
    return snapshot.docs
        .map((doc) => ActiveTaskModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> addActiveTask(ActiveTaskModel activeTask) async {
    final normalizedActiveTask =
        activeTask.copyWith(userEmail: activeTask.userEmail.trim().toLowerCase());
    await _db
        .collection('active_tasks')
        .doc(normalizedActiveTask.id)
        .set(normalizedActiveTask.toJson())
        .timeout(_timeout);
  }

  Future<void> removeActiveTask(String id, String email) async {
    await _db
        .collection('active_tasks')
        .doc(id)
        .delete()
        .timeout(_timeout);
  }

  // --- DB Operations: Submissions ---

  Future<List<SubmissionModel>> getSubmissions() async {
    final snapshot = await _db
        .collection('submissions')
        .orderBy('id', descending: true)
        .get()
        .timeout(_timeout);
    return snapshot.docs
        .map((doc) => SubmissionModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> submitReport(SubmissionModel submission) async {
    await _db
        .collection('submissions')
        .doc(submission.id)
        .set(submission.toJson())
        .timeout(_timeout);
  }

  Future<void> reviewSubmission(String submissionId, String status) async {
    final doc = await _db
        .collection('submissions')
        .doc(submissionId)
        .get()
        .timeout(_timeout);
    if (!doc.exists || doc.data() == null) return;
    final sub = SubmissionModel.fromJson(doc.data()!);

    // Remove from submissions queue
    await _db
        .collection('submissions')
        .doc(submissionId)
        .delete()
        .timeout(_timeout);

    if (status == 'approved') {
      // Find user by name and award points
      final snapshot = await _db
          .collection('users')
          .where('name', isEqualTo: sub.volunteerName)
          .get()
          .timeout(_timeout);
      if (snapshot.docs.isNotEmpty) {
        final userDoc = snapshot.docs.first;
        final user = UserModel.fromJson(userDoc.data());
        final newPoints = user.points + 200;
        final newCompleted = user.tasksCompletedCount + 1;
        final newHours = user.timeDonatedHours + 2;
        final newLevel = 1 + (newPoints ~/ 500);

        await _db.collection('users').doc(user.email).update({
          'points': newPoints,
          'tasksCompletedCount': newCompleted,
          'timeDonatedHours': newHours,
          'level': newLevel,
        }).timeout(_timeout);
      }
    }
  }
}
