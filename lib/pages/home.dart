import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:monopoly_banker/class_structure/player.dart';
import 'package:monopoly_banker/widgets/player_avatar.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Monopoly Banker"),
          centerTitle: true,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
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
                height: MediaQuery.of(context).size.height * 0.6,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: GridView.builder(
                    itemCount: value.players.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 210 / 200,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) => PlayerAvatar(
                      player: value.players[index],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            value.addTransaction("Player 1", "Player 2", 241);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
