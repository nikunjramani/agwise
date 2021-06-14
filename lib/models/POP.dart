class POP{
  String title;
  List<SubPop> subPopList;

  POP(this.title, this.subPopList);
}

class SubPop{
  String subtitle;
  List<String> details;
  SubPop(this.subtitle, this.details);
}