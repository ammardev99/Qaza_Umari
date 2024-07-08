import 'package:flutter/cupertino.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SliderModel {
  String imagePath;
  String title;
  String desc;

  SliderModel(
      {required this.imagePath, required this.title, required this.desc});

  void setImageAssetPath(String getImagePath) {
    imagePath = getImagePath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imagePath;
  }

  String getTitle() {
    return title;
  }

  String getdesc() {
    return desc;
  }
}

List<SliderModel> getSlides(BuildContext context) {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = SliderModel(
      imagePath: "assets/images/regular.png",
      title:" Welcome to the Qaza-e-Umri",
      desc: "Track your regular prayer and get notified at your preferred time before namaz. Very user friendly mobile app.",
          );
  slides.add(sliderModel);

  sliderModel = SliderModel(
      imagePath: "assets/images/qaza.png",
      title: "Qaza Umri",
      desc:
     " A very user friendly and helpful app to keep track of your qasar qaza namaz.",
      );
  slides.add(sliderModel);

  sliderModel = SliderModel(
      imagePath: "assets/images/qasar.png",
      title: "Qasar Qaza",
      desc:
        "A very user friendly and helpful app to keep track of your qasar qaza namaz.");
  slides.add(sliderModel);

  return slides;
}
