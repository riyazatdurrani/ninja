class User{
  String name;
  String password;
  


User({required this.name,required this.password});

factory User.fromMap(Map user){
  return User(name: user["name"], 
  password: user["password"]
  );
}

Map toMap(){
  return {
    "name":name,
    "password": password,
  };
}   

}