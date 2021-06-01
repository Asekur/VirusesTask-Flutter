class Virus {
  late String uid;
  late String fullName;
  late String country;
  late String continent;
  late String domain;
  late String mortality;
  late String password;
  late String photoLink;
  late String year;
  late String videoLink;

  Virus(String uid, String fullName, String country, String continent,
      String domain, String mortality, String password, String year,
      String photoLink, String videoLink) {
    this.uid = uid;
    this.fullName = fullName;
    this.country = country;
    this.continent = continent;
    this.domain = domain;
    this.mortality = mortality;
    this.password = password;
    this.year = year;
    this.photoLink = photoLink;
    this.videoLink = videoLink;
  }
}