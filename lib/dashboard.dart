import 'package:flutter/material.dart';
import 'package:practical_app/home_screen.dart';
import 'package:practical_app/login_screen.dart';
import 'package:practical_app/profile_screen.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key, required this.tokenMap});

  final Map<String, dynamic> tokenMap;

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My DashBoard"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple.shade300,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
              }, 
              icon: const Icon(Icons.logout, color: Colors.white,)
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home, color: Colors.white,),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.white,),
                text: "Profile",
              )
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 5,
          ),
        ),
        body: TabBarView(
          children: [
            const HomeScreen(),
            MyProfile(userMap: widget.tokenMap,)
          ],
        ),
      ),
    );
  }
}