import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:monopoly_banker/class_structure/player.dart';
import 'package:provider/provider.dart';

class ManageGameDialogue extends StatefulWidget {
  ManageGameDialogue({super.key});

  @override
  State<ManageGameDialogue> createState() => _ManageGameDialogueState();
}

class _ManageGameDialogueState extends State<ManageGameDialogue> {
  final TextEditingController initAmountController = TextEditingController();
  String? initAmountError;

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(builder: (context, game, child) {
      game.getGameFromHive();
      initAmountController.text = game.startingAmount.toString();

      return AlertDialog(
        title: const Text(
          "Manage Game",
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            height: 450,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Reset Money Button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Are you sure you want to reset all accounts to ${game.startingAmount}\$?",
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              game.resetAllAccounts();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Reset All Accounts"),
                ),

                Text(
                  "Initial Amount: ",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey[300],
                  ),
                ),

                // Change Initial Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 80,
                      child: TextField(
                        controller: initAmountController,
                        decoration: InputDecoration(
                          errorText: initAmountError,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (int.tryParse(initAmountController.text) != null) {
                          game.changeStartingAmount(
                              int.parse(initAmountController.text));
                          setState(() {
                            initAmountError = null;
                          });
                        } else {
                          setState(() {
                            initAmountError = "Invaild";
                          });
                        }
                      },
                      child: const Text("Change"),
                    ),
                  ],
                ),

                Text(
                  "Manage Players: ",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey[300],
                  ),
                ),

                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView.builder(
                    itemCount: game.players.length,
                    itemBuilder: (context, index) => PlayerTile(
                      player: game.players[index],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class PlayerTile extends StatelessWidget {
  const PlayerTile({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(builder: (context, game, child) {
      game.getGameFromHive();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(player.name),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                            "Are you sure you want to delete player ${player.name}?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              game.removePlayer(player.name);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
