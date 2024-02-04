import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monopoly Banker"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),

            // Bank
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 44, 44, 44),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text("BANK", style: TextStyle(fontSize: 30)),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            // GridView
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                child: GridView.count(
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                  mainAxisSpacing: 20,
                  crossAxisCount: 3,
                  children: const [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Color.fromARGB(255, 51, 51, 51),
                    ),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Color.fromARGB(255, 51, 51, 51),
                    ),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Color.fromARGB(255, 51, 51, 51),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
