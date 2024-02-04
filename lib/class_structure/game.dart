import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/player.dart';
import 'package:monopoly_banker/class_structure/transaction.dart';

class Game extends ChangeNotifier {
  Game();
  int loadedGameIndex = 1;

  int startingAmount = 200;

  List<Player> players = [
    Player("Player 1", 1000),
    Player("Player 2", 100),
    Player("Player 3", -232),
  ];
  List<Transaction> transactions = [];

  void addPlayer(String playerName) {
    if (playerName != "__BANK__") {
      players.add(Player(playerName, startingAmount));
    }

    notifyListeners();
  }

  void removePlayer(String playerName) {
    players.removeWhere((element) => element.name == playerName);

    notifyListeners();
  }

  void addTransaction(String fromPlayer, String toPlayer, int amount) {
    if ((fromPlayer == "__BANK__" ||
            players
                .where((element) => element.name == fromPlayer)
                .isNotEmpty) &&
        (fromPlayer == "__BANK__" ||
            players.where((element) => element.name == toPlayer).isNotEmpty)) {
      // subtract money from fromPlayer
      if (fromPlayer != "__BANK__") {
        int fromPlayerIndex =
            players.indexWhere((element) => element.name == fromPlayer);

        players[fromPlayerIndex].takeMoney(amount);
      }

      // add money to toPlayer
      if (toPlayer != "__BANK__") {
        int toPlayerIndex =
            players.indexWhere((element) => element.name == toPlayer);

        players[toPlayerIndex].giveMoney(amount);
      }

      // add transaction object to list
      transactions.add(Transaction(fromPlayer, toPlayer, amount));

      notifyListeners();
    }
  }
}
