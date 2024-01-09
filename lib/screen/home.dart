import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'navs/googlemap.dart';
import 'navs/dashboard.dart';
import 'navs/setting.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserState();
}

class _UserState extends State<UserPage> {
  late SharedPreferences prefs;
  bool isLoading = false;

  String token = '';

  @override
  void initState() {
    getUserData();
    getToken();
    super.initState();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  void getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token').toString();
  }

  void logout() {
    prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }


  void showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform logout actions
                logout();
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePageContent(),
    const DashboardPage(),
    const SettingPage(), // Settings Page Content
    const MapPage(),            // Map Page
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      // Override the back button behavior
      onWillPop: () async {
        // Return false to prevent navigation back to the previous page
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D7377),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(prefs.getString('name').toString()),
                accountEmail: Text(prefs.getString('email').toString()),
                currentAccountPicture: const CircleAvatar(
                  // Add your profile picture here
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  setState(() {
                    _currentIndex = 0; // Set the current index to Home
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text("Dashboard"),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  setState(() {
                    _currentIndex = 1; // Set the current index to Home
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  setState(() {
                    _currentIndex = 2; // Set the current index to Settings
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text("Map"),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  setState(() {
                    _currentIndex = 3; // Set the current index to Map
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  showLogoutConfirmationDialog();
                },
              ),
            ],
          ),
        ),
        body: _pages[_currentIndex],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> carouselImages = [
      'assets/banner1.png',
      'assets/banner2.png',
    ];

    double screenHeight = MediaQuery.of(context).size.height * 0.25;

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: screenHeight,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            pauseAutoPlayOnTouch: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              // Handle page change
            },
          ),
          items: carouselImages.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              // Handle search query changes here
              // You can use the value for filtering or searching.
            },
          ),
        ),
      ],
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}
