class calculations{
  double contri ({required double amount, required List<String> members}){
    double contri= 0;
    contri = amount / members.length;
    return contri;
  }
}