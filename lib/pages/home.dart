import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:monopoly_banker/class_structure/player.dart';
import 'package:monopoly_banker/dialogues/add_game.dart';
import 'package:monopoly_banker/dialogues/money_transfer_dialogue.dart';
import 'package:monopoly_banker/widgets/drag_widget.dart';
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
    return Consumer<Game>(builder: (context, game, child) {
      game.getGameFromHive();

      return Scaffold(
        appBar: AppBar(
          title: const Text("Monopoly Banker"),
          centerTitle: true,
        ),
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.background,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SAVED GAMES",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                    itemCount: game.getGameNamesList().length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(game.getGameNamesList()[index]),
                      tileColor: game.gameName == game.getGameNamesList()[index]
                          ? Theme.of(context).colorScheme.background
                          : Colors.transparent,
                      onTap: () {
                        setState(() {
                          game.switchToGame(game.getGameNamesList()[index]);
                        });
                      },
                      trailing: game.gameName != game.getGameNamesList()[index]
                          ? IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                              ),
                              onPressed: () {
                                game.removeGame(game.getGameNamesList()[index]);
                              },
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddGameDialogue(),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Add New Game"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
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
                      itemCount: game.players.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 210 / 200,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) => DragTarget(
                        builder: (context, candidateItems, rejectedItems) {
                          return LongPressDraggable(
                            data: game.players[index].name,
                            feedback: const DragWidget(),
                            child: PlayerAvatar(
                              player: game.players[index],
                            ),
                          );
                        },
                        onAccept: (String fromPlayerName) {
                          showDialog(
                            context: context,
                            builder: (context) => MoneyTransferDialogue(
                              fromPlayer: fromPlayerName,
                              toPlayer: game.players[index].name,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            game.addTransaction("Player 1", "Player 2", 241);
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
