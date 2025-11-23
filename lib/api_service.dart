import 'dart:convert';
import 'package:http/http.dart' as http;
import 'item.dart';

class ApiService {
  static const String baseUrl =
      "https://6921a1e5512fb4140be0d736.mockapi.io/item";

  static Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse(baseUrl));

    print("GET status: ${response.statusCode}");
    print("GET body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception("GET gagal: ${response.statusCode}");
    }
  }

  static Future<Item> addItem(String title, String description) async {
    final body = jsonEncode({
      "title": title,
      "description": description,
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("POST status: ${response.statusCode}");
    print("POST body: ${response.body}");

    if (response.statusCode == 201) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("POST gagal: ${response.statusCode}");
    }
  }

  static Future<Item> updateItem(
    String id,
    String title,
    String description,
  ) async {
    final body = jsonEncode({
      "title": title,
      "description": description,
    });

    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("PUT status: ${response.statusCode}");
    print("PUT body: ${response.body}");

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("PUT gagal: ${response.statusCode}");
    }
  }

  static Future<void> deleteItem(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    print("DELETE status: ${response.statusCode}");
    print("DELETE body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("DELETE gagal: ${response.statusCode}");
    }
  }
}
