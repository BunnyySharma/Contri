class people {
  String name;
  int you_owe = 0;
  int owes_you = 0;

  people({required this.name, required this.owes_you, required this.you_owe});
}
class peopleinfo{
  List<people> total = [];
  void add() {
    List<Map<String,dynamic>> temp= [
      {"name": "Birju", "owes_you": 200, "you_owe": 0},
      {"name": "Nish", "owes_you": 200, "you_owe": 0},
      {"name": "Aditya", "owes_you": 0, "you_owe": 100},
      {"name": "Saint", "owes_you": 10000, "you_owe": 0},
      {"name": "neem", "owes_you": 100, "you_owe": 0},
      {"name": "Papa", "owes_you": 0, "you_owe": 100000},
    ];
    total = temp.map((data) {
      return people(
        name: data["name"],
        owes_you: data["owes_you"],
        you_owe: data["you_owe"],
      );
    }).toList();
  }
  // void printinfo(){
  //   total.map((people){
  //     if (people.you_owe != 0)
  //     {
  //       print("you owe ${people.name} : ${people.you_owe}");
  //     }
  //     if(people.owes_you != 0)
  //     {
  //       print("${people.name} owes you: ${people.owes_you}");
  //     }
  //   }).toList();
  // }
}