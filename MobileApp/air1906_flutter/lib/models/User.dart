import './UserRole.dart';
import './Shop.dart';

class User {
  String id;
  String ime;
  String prezime;
  String telefon;
  String adresa;
  String email;
  String oib;
  String username;
  String password;
  UserRole uloga;
  Shop poslovnica;

  User({
    this.id,
    this.ime,
    this.prezime,
    this.telefon,
    this.adresa,
    this.email,
    this.oib,
    this.username,
    this.password,
    this.uloga,
    this.poslovnica,
  });

  bool isAdmin() {
    if (int.parse(uloga.id) == 1){
      return true;
    } 
    else {
      return false;
    }
  }
  @override
  String toString() {
    return "Korisnik: $ime";
  }
}
