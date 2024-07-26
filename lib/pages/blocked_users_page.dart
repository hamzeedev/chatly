import 'package:chatly/components/user_tile.dart';
import 'package:chatly/services/auth/auth_services.dart';
import 'package:chatly/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
   BlockedUsersPage({super.key});

  //! chat & auth services
  final ChatServices chatServices = ChatServices();
  final AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {

    //! get current users id --
    String userId = authServices.getCurrentUser()!.uid;

    //! show confirm unblock box
    void showUnblockBox(BuildContext context, String userId){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Unblocked User"),
          content: const Text("Are you sure you want to unblock this user?"),
          actions: [
            //* cancel button ..
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("Cancel"),
              ),

            //* unblock button ..
            TextButton(
              onPressed: (){
                chatServices.unblockUser(userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User unblocked")));
              },
              child: const Text("Unblock"),
              ),   
          ],
        )
        );
    }

    //! UI
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("BLOCKED USERS"),
        actions: const [],
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatServices.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          
          //* errors..
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading.."),
            );
          }
          //* loading..
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blockedUsers = snapshot.data ?? [];

          //* no users
          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text("No Blocked Users"),
            );
          }

          //* load complete
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user["email"], 
                onTap: () => showUnblockBox(context, user['uid']),
              );
            },
          );
        },
      ),
    );
  }
}