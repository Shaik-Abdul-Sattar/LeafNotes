class AppUser {
  final String uid;
  final String email;
  final String username;

  AppUser({required this.uid, required this.email, required this.username});

  //JSON to Appuser (object)
  factory AppUser.fromJSON(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      username: jsonUser['username'],
    );
  }

  //Appuser(object) to JSON
  Map<String, dynamic> toJSON(){
    return {
      'uid' : uid,
      'email' : email,
      'username' : username
    };
  } 
}
