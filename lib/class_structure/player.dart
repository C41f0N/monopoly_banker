class Player {
  String name;
  int accountBalance;

  Player(this.name, this.accountBalance);

  void giveMoney(int amount) {
    accountBalance += amount;
  }

  void takeMoney(int amount) {
    accountBalance -= amount;
  }
}
