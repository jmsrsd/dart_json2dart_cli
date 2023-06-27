import 'serialize.dart';

extension MapJson<K, V> on Map<K, V> {
  Map<String, dynamic> get json {
    return serialize(this);
  }
}

extension StringJson on String {
  Map<String, dynamic> get json {
    return serialize(this);
  }
}
