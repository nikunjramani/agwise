class Chat{
  int id;
  String msg,type;
  bool issendbyme;
  static final columns = ["id", "msg", "issendbyme", "type"];
  Chat(this.id,this.msg, this.issendbyme,this.type);

  factory Chat.fromMap(Map<String, dynamic> data) {
    return Chat(
      data['id'],
      data['msg'],
      data['issendbyme'],
      data['type'],
    );
  }

  Chat.fromJson(Map<String,dynamic> json){
    id=json['id'];
    msg=json['msg'];
    issendbyme=json['issendbyme'];
    type=json['type'];
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "msg": msg,
    "issendbyme": issendbyme,
    "type": type
  };

}