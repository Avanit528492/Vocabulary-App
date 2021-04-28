class Details
{
  int _id;
  String _spell;
  String _meaning;
  String _synonyms;


  Details(String spell , String meaning , [String synonyms = 'NA'])
  {
    this._spell = spell;
    this._meaning = meaning;
    this._synonyms = synonyms;
  }
  Details.withId(int id , String spell , String meaning , [String synonyms = 'NA'])
  {
    this._id = id;
    this._spell = spell;
    this._meaning = meaning;
    this._synonyms = synonyms;
  }


  int get id => _id;
  String get spell => _spell;
  String get meaning => _meaning;
  String get synonyms => _synonyms;

  set id(int id) => this._id = id;
  set spell(String spell) => this._spell = spell;
  set meaning(String meaning) => this._meaning =meaning;
  set synonyms(String synonyms) => this._synonyms = synonyms;

  Map<String , dynamic> toMap()
  {
    Map<String , dynamic> map = Map();
    if(id!=null)
    map['spell'] = spell;
    map['meaning'] = meaning;
    if(synonyms == null)
      {
        map['synonyms'] = "NA";
      }
    else{
      map['synonyms'] = synonyms;
    }
  }

  Details.formMapToObject(Map<String , dynamic> map)
  {
    this._id = map['id'];
    this._spell = map['spell'];
    this._meaning = map['meaning'];
    this._synonyms = map['synonyms'];
  }


}