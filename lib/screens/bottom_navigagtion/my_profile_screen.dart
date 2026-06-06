import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../login/login_controller.dart';
import 'bottom_controller.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final LoginController profilecontroller = Get.find<LoginController>();
  final bottomController = Get.find<BottomController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // Yellow background background aur white/black elements ka combination
        backgroundColor: Colors.yellow[700], // Thoda premium look ke liye rich yellow
        elevation: 0.5,
        foregroundColor: Colors.black, // Icons ka color automatic black ho jayega

        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: false, // Search bar layout ke sath consistency ke liye left align sahi rahega

        actions: [
          if (MediaQuery.of(context).size.width >= 600)
          // Right side mein Menu Button page switch karne ke liye
          PopupMenuButton<int>(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onSelected: (index) {
              // GetX controller ke index ko change karega
              bottomController.change(index);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 0, // Home ka index
                  child: Row(
                    children: [
                      Icon(Icons.home, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Home'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 1, // Profile ka index (Current page)
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Profile'),
                    ],
                  ),
                ),
              ];
            },
          ),
          const SizedBox(width: 8), // Margin ke liye
        ],
      ),
      body: Obx(() {
        // 1. Loading State
        if (profilecontroller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.yellow));
        }

        // 2. Error Case
        if (profilecontroller.currentUser.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 10),
                const Text("Data nahi mil raha. Naya login karein."),
                TextButton(
                  onPressed: () => profilecontroller.fetchUserProfile(),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        var user = profilecontroller.currentUser;

        return SingleChildScrollView(
          child: Column(
            children: [
              // --- Header Section with Gradient & Avatar ---
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.yellowAccent, Colors.yellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          user['avatar'] ?? "https://via.placeholder.com/150",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // --- User Identity Section ---
              Text(
                user['name']?.toString().toUpperCase() ?? "GUEST USER",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                user['email'] ?? "No email linked",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // --- Information Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    InkWell(onTap: (){

                    },child: _buildInfoTile(Icons.person_outline, "Username", user['name'] ?? "N/A")),
                    _buildInfoTile(Icons.email_outlined, "Email Address", user['email'] ?? "N/A"),
                    _buildInfoTile(Icons.verified_user_outlined, "Role", user['role'] ?? "Customer"),


                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),

                    // --- Logout Button ---
                    ListTile(
                      onTap: () => _showLogoutDialog(),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                        child: const Icon(Icons.logout, color: Colors.red),
                      ),
                      title: const Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Info Tile Widget for Consistency
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      ),
    );
  }

  // Innovative Logout Confirmation Dialog
  void _showLogoutDialog() {
    Get.defaultDialog(
      title: "Logout Confirmation",
      middleText: "Do you want to Logout?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        GetStorage().erase();
        Get.offAllNamed('/login'); // Login screen par wapas bhej do
      },
    );
  }
}
