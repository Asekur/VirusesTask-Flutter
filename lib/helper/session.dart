// @dart=2.9
import 'package:flutter_viruses/helper/virus.dart';

class Session {
  static Session shared = new Session();
  Virus virus;
  Virus detailVirus;
  List<Virus> viruses = [];
  List<Virus> resultViruses = [];
}