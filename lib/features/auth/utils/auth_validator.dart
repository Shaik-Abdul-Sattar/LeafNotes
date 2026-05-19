class AuthValidator {

  static String? validateUsername(String value){
    if(value.trim().isEmpty){
      return "Username required";
    }

    if(value.length < 4){
      return "Minimum 4 characters required";
    }
    
    return null;
  }

  static String? validateEmail(String value){
    if(value.trim().isEmpty){
      return "Email required";
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if(!emailRegex.hasMatch(value)){
      return "Invalid Email";
    }

    return null;
  }

  static String? validatePassword(String value){
    if(value.trim().isEmpty){
      return "Password required";
    }

    if(value.length < 6){
      return "Minimum 6 characters required";
    }

    return null;
  }
}