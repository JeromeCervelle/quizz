class Question {

  String question;
  bool reponse;
  String explication;
  String imagePath;

  String get imageString => 'images/$imagePath';

  Question({
    required this.question,
    required this.reponse,
    required this.explication,
    required this.imagePath
  });


}