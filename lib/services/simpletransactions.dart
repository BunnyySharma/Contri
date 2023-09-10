import 'package:fontcontri/models/tmodel.dart';

List<transactionmodel> simplify(Map<String, double> balances){
  List<String> posBalances = balances.keys.where((person) => balances[person]! > 0).toList();
  List<String> negBalances = balances.keys.where((person) => balances[person]! < 0).toList();
  negBalances.sort((a, b) => balances[a]!.abs().compareTo(balances[b]!.abs()));
  posBalances.sort((a, b) => balances[a]!.compareTo(balances[b]!));
  List<transactionmodel> transactions = [];

  while (posBalances.isNotEmpty && negBalances.isNotEmpty){
    String creditor = posBalances.removeLast();
    String debtor = negBalances.removeLast();
    double amount = 0;
    double subval = balances[creditor]!+ balances[debtor]!;
    if(subval>0){
      amount = balances[debtor]!.abs();
    }else{
     amount = balances[creditor]!;
    }
    balances[creditor] = balances[creditor]! - amount;
    balances[debtor] = balances[debtor]! + amount;
    if(balances[creditor] != 0){
      posBalances.add(creditor);
      posBalances.sort((a, b) => balances[a]!.compareTo(balances[b]!));
    }
    if(balances[debtor] != 0){
      negBalances.add(debtor);
      negBalances.sort((a, b) => balances[a]!.abs().compareTo(balances[b]!.abs()));
    }
    transactions.add(transactionmodel(creditor: creditor, debtor: debtor, amount: amount));
  }
  return transactions;
}