import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monopoly_banker/class_structure/player.dart';
import 'package:monopoly_banker/class_structure/transaction.dart';

class Game extends ChangeNotifier {
  Game() {
    gameName = _myBox.get("__CURRENT_GAME_NAME__");

    if (gameName == null) {
      List<String> gamesList = _myBox.get("__GAMES_LIST__");

      if (gamesList.isEmpty) {
        setDefaultData();
        addGame();

        saveGameToHive();
      } else {
        gameName = gamesList[0];
        _myBox.put("__CURRENT_GAME_NAME__", gameName);
        getGameFromHive();
      }
    }
  }

  String? gameName;
  final _myBox = Hive.box("__MONOPOLY_BANKER_DATABASE__");

  int startingAmount = 500;
  int goAmount = 200;

  List<Player> players = [];
  List<Transaction> transactions = [];

  void setDefaultData() {
    gameName = "First Game";
    goAmount = 200;
    startingAmount = 500;

    // Set initial Players
    players = [
      Player("Player 1", startingAmount),
      Player("Player 2", startingAmount),
      Player("Player 3", -startingAmount),
    ];

    transactions = [];
  }

  void addGame() {
    List<String> gamesList = _myBox.get("__GAMES_LIST__");

    gamesList.add(gameName!);

    _myBox.put("__GAMES_LIST__", gamesList);

    notifyListeners();
  }

  void removeGame(String gameNameToRemove) {
    // Remove from the game names list
    List<String> gamesList = _myBox.get("__GAMES_LIST__");

    gamesList.remove(gameNameToRemove);

    _myBox.put("__GAMES_LIST__", gamesList);

    // Delete Save Amount
    _myBox.put("${gameNameToRemove}__startingAmount", null);

    // Delete Go Amount
    _myBox.put("${gameNameToRemove}__goAmount", null);

    // Delete Players List
    _myBox.put("${gameName}__players", null);

    // Delete Transactions List
    _myBox.put("${gameName}__transactions", null);

    notifyListeners();
  }

  void saveGameToHive() {
    // Save Starting Amount
    _myBox.put("${gameName}__startingAmount", startingAmount);

    // Save Go Amount
    _myBox.put("${gameName}__goAmount", goAmount);

    // Save Players List
    List<String> playersListString = [];

    for (Player player in players) {
      playersListString.add("${player.name},${player.accountBalance}");
    }

    _myBox.put("${gameName}__players", playersListString);

    // Save Transactions List
    List<String> transactionsListString = [];

    for (Transaction transaction in transactions) {
      transactionsListString.add(
          "${transaction.fromPlayer},${transaction.toPlayer},${transaction.amount}");
    }

    _myBox.put("${gameName}__transactions", transactionsListString);
  }

  void getGameFromHive() {
    // Get Starting Amount
    startingAmount = _myBox.get("${gameName}__startingAmount");

    // Get Go Amount
    goAmount = _myBox.get("${gameName}__goAmount");

    // Get Players List
    List<String> playersListString = _myBox.get("${gameName}__players");
    players = [];

    for (String playerData in playersListString) {
      String playerName = playerData.split(",")[0];
      int accountBalance = int.parse(playerData.split(",")[1]);
      players.add(Player(playerName, accountBalance));
    }

    // Get Transactions List
    List<String> transactionsListString =
        _myBox.get("${gameName}__transactions");

    transactions = [];

    for (String transactionData in transactionsListString) {
      String fromPlayer = transactionData.split(",")[0];
      String toPlayer = transactionData.split(",")[1];
      int amount = int.parse(transactionData.split(",")[3]);

      transactions.add(Transaction(fromPlayer, toPlayer, amount));
    }
  }

  void addPlayer(String playerName) {
    if (playerName != "__BANK__") {
      players.add(Player(playerName, startingAmount));
    }

    saveGameToHive();
    notifyListeners();
  }

  void removePlayer(String playerName) {
    players.removeWhere((element) => element.name == playerName);

    saveGameToHive();
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

      saveGameToHive();
      notifyListeners();
    }
  }

  List<String> getGameNamesList() {
    List<String>? gameNamesList = _myBox.get("__GAMES_LIST__");

    if (gameNamesList == null) {
      return [];
    }

    return gameNamesList;
  }

  void switchToGame(String gameNameToSwitch) {
    if (getGameNamesList().contains(gameNameToSwitch)) {
      gameName = gameNameToSwitch;
      getGameFromHive();
    }
  }
}
