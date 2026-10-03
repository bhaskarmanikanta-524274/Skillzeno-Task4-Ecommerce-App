import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class CartItem { final Product product; int quantity; CartItem(this.product,[this.quantity=1]); double get total=>product.price*quantity; }
class CartState extends ChangeNotifier {
  final List<CartItem> items=[];
  int get count=>items.fold(0,(s,e)=>s+e.quantity);
  double get total=>items.fold(0,(s,e)=>s+e.total);
  void add(Product p){final i=items.indexWhere((e)=>e.product.id==p.id); if(i<0)items.add(CartItem(p));else items[i].quantity++;notifyListeners();}
  void inc(Product p){final i=items.indexWhere((e)=>e.product.id==p.id);if(i>=0)items[i].quantity++;notifyListeners();}
  void dec(Product p){final i=items.indexWhere((e)=>e.product.id==p.id);if(i<0)return;if(items[i].quantity>1)items[i].quantity--;else items.removeAt(i);notifyListeners();}
  void remove(Product p){items.removeWhere((e)=>e.product.id==p.id);notifyListeners();}
}
class AuthState extends ChangeNotifier {
  static const firebaseEnabled=false;
  bool loading=false; String? email; String? error;
  Future<bool> login(String e,String p) async {
    loading=true;error=null;notifyListeners();
    try { if(firebaseEnabled){final c=await FirebaseAuth.instance.signInWithEmailAndPassword(email:e.trim(),password:p);email=c.user?.email??e.trim();}
      else {if(e.trim()!='demo@skillzeno.com'||p!='123456') throw Exception('Demo login: use demo@skillzeno.com / 123456');email=e.trim();}
      loading=false;notifyListeners();return true;
    } catch(x){error=x.toString().replaceFirst('Exception: ','');loading=false;notifyListeners();return false;}
  }
  Future<bool> signup(String e,String p) async {
    loading=true;error=null;notifyListeners();
    try {if(p.length<6)throw Exception('Password must contain at least 6 characters.');
      if(firebaseEnabled){final c=await FirebaseAuth.instance.createUserWithEmailAndPassword(email:e.trim(),password:p);email=c.user?.email??e.trim();}else{email=e.trim();}
      loading=false;notifyListeners();return true;
    } catch(x){error=x.toString().replaceFirst('Exception: ','');loading=false;notifyListeners();return false;}
  }
  Future<void> logout() async {if(firebaseEnabled)await FirebaseAuth.instance.signOut();email=null;error=null;notifyListeners();}
}
