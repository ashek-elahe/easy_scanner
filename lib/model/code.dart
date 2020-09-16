class Code {
  int _id;
  int _type;
  String _title;
  String _result;

  Code(this._type, this._title, this._result);
  Code.withId(this._id, this._type, this._title, this._result);

  int get id => _id;
  int get type => _type;
  String get title => _title;
  String get result => _result;

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map();
    if(id != null) {
      map["id"] = _id;
    }
    map["type"] = _type;
    map["title"] = _title;
    map["result"] = _result;

    return map;
  }

  Code.fromMapObject(Map<String, dynamic> map){
    this._id = map["id"];
    this._type = map["type"];
    this._title = map["title"];
    this._result = map["result"];
  }
}