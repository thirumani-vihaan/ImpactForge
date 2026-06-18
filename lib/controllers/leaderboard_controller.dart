import 'package:get/get.dart';
import '../models/leaderboard_model.dart';
import '../services/firestore_service.dart';

class LeaderboardController extends GetxController {
  static LeaderboardController get to => Get.find();

  final leaderboardUsers = <LeaderboardModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    isLoading.value = true;
    try {
      final list = await FirestoreService.to.getLeaderboard();
      leaderboardUsers.assignAll(list);
    } catch (e) {
      Get.log("Error fetching leaderboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Get podium users (Top 3)
  List<LeaderboardModel> get podiumUsers {
    if (leaderboardUsers.isEmpty) return [];
    // The items returned from Supabase are sorted by rank.
    // If they aren't, sort them first:
    final sorted = List<LeaderboardModel>.from(leaderboardUsers);
    sorted.sort((a, b) => a.rank.compareTo(b.rank));
    return sorted.take(3).toList();
  }

  // Get other list users (4th onwards)
  List<LeaderboardModel> get otherUsers {
    if (leaderboardUsers.length <= 3) return [];
    final sorted = List<LeaderboardModel>.from(leaderboardUsers);
    sorted.sort((a, b) => a.rank.compareTo(b.rank));
    return sorted.skip(3).toList();
  }

  // Get user rank index based on name
  int getUserRank(String name) {
    final index = leaderboardUsers.indexWhere((u) => u.name.toLowerCase() == name.toLowerCase());
    return index != -1 ? leaderboardUsers[index].rank : -1;
  }
}
