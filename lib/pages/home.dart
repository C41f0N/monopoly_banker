import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:monopoly_banker/dialogues/add_game_dialogue.dart';
import 'package:monopoly_banker/dialogues/money_transfer_dialogue.dart';
import 'package:monopoly_banker/dialogues/add_player_dialogue.dart';
import 'package:monopoly_banker/dialogues/transactions_list.dart';
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
          backgroundColor: Colors.transparent,
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
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Transactions
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => TransactionsListDialogue());
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 44, 44, 44),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.history,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),

                    DragTarget(
                      builder: (context, candidateItems, rejectedItems) {
                        return LongPressDraggable(
                          data: "__BANK__",
                          feedback: const DragWidget(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 44, 44, 44),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text("BANK",
                                style: TextStyle(fontSize: 30)),
                          ),
                        );
                      },
                      onAccept: (String fromPlayerName) {
                        showDialog(
                          context: context,
                          builder: (context) => MoneyTransferDialogue(
                            fromPlayer: fromPlayerName,
                            toPlayer: "__BANK__",
                          ),
                        );
                      },
                    ),

                    // Bank

                    // Manage Game
                    Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 44, 44, 44),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.settings,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
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
            if (game.players.length >= 6) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Maximum number or players reached!"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Got it."),
                    )
                  ],
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => const AddPlayerDialogue(),
              );
            }
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
