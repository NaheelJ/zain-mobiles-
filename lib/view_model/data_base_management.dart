import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';

class DataBaseManagement extends ChangeNotifier {
  // Category Adding State management
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Category Adding Controller
  TextEditingController categoryNameController = TextEditingController();
  List<TextEditingController> categoryTypesController = [TextEditingController()];

///////////////////////////////////////////////////////////////////////////////////////////////////////

  void addMoreTypes() {
    TextEditingController controller = TextEditingController();
    categoryTypesController.add(controller);
    notifyListeners();
  }

  void removeTypeController(value) {
    categoryTypesController.remove(value);
    notifyListeners();
  }

  void clearAllCategoryControllers() {
    categoryNameController.clear();
    categoryTypesController = [TextEditingController()];
    notifyListeners();
  }

// Product Adding State management
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

  // Product Adding variables
  TextEditingController productNameController = TextEditingController();
  List<TextEditingController> suitableFor = [TextEditingController()];
  String selectedCategory = '';
  String productSelectedType = '';

///////////////////////////////////////////////////////////////////////////////////////////////////////

  void assignCategory(newValue) async {
    selectedCategory = newValue;
  }

  void assignProductSelectedType() {
    final types = listData.firstWhere((item) => item["Category"] == selectedCategory)["type"];
    if (types.isNotEmpty && types.first != null) {
      productSelectedType = types.first;
      return;
    }
    productSelectedType = "";
  }

  void setProductSelectedType(newValue) {
    productSelectedType = newValue;
    notifyListeners();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////

  void setCategory(newValue) async {
    selectedCategory = newValue;
    notifyListeners();
  }

  void addTextField() {
    TextEditingController controller = TextEditingController();
    suitableFor.add(controller);
    notifyListeners();
  }

  void removeTextField(value) {
    suitableFor.remove(value);
    notifyListeners();
  }

  void clearAllProductControllers() {
    productNameController.clear();
    suitableFor = [TextEditingController()];
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////
  // Data Base Management
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
  // Loading managemnt Variable
  bool isLoading = false;
  List<dynamic> listData = [];
  TextEditingController suitableForcontroller = TextEditingController();
  final collectionId = "zainMobiles";
  final documentId = "zainmobiles";

///////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> fetchFromServer() async {
    final documentRef = FirebaseFirestore.instance.collection(collectionId).doc(documentId);
    try {
      // Always fetch from the server
      DocumentSnapshot snapshot = await documentRef.get(GetOptions(source: Source.server));

      if (snapshot.exists && snapshot.data() != null) {
        listData = snapshot.get('data') ?? [];
      } else {
        print("Document does not exist or contains no data.");
      }
    } catch (e) {
      print("Data Fetching Error: $e");
    }
    notifyListeners();
  }

  Future<void> fetch() async {
    final documentRef = FirebaseFirestore.instance.collection(collectionId).doc(documentId);
    try {
      // Offline persistence will prioritize cache data
      DocumentSnapshot snapshot = await documentRef.get(GetOptions(source: Source.cache)); // Fetch from cache first

      if (!snapshot.exists) {
        // If not found in cache, fetch from server
        snapshot = await documentRef.get(GetOptions(source: Source.server));
      }

      if (snapshot.exists && snapshot.data() != null) {
        listData = snapshot.get('data') ?? [];
      } else {
        print("Document does not exist or contains no data.");
      }
    } catch (e) {
      print("Data Fetching Error: $e");
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> addNewCategory({
    required String categoryName,
    required List<String> type,
  }) async {
    bool categoryExists = false;

    // Early return if the category name is empty
    if (categoryName.isEmpty) {
      showToast(msg: "Fill out the required fields", textColor: Colors.redAccent);
      return;
    } else if (type.length == 1 && type[0] == "") {
      showToast(msg: "Fill out the required fields", textColor: Colors.redAccent);
      return;
    }

    var newCategory = {};
    if (type.length == 1 && type.first == "") {
      newCategory = {
        "Category": capitalizeEachWord(categoryName),
        "type": [],
        "products": [],
      };
    } else {
      newCategory = {
        "Category": capitalizeEachWord(categoryName),
        "type": capitalizeFirstLettersOfList(type),
        "products": [],
      };
    }

    try {
      isLoading = true;
      notifyListeners();

      // Reference to the Firestore document
      final documentRef = FirebaseFirestore.instance.collection(collectionId).doc(documentId);

      // Fetch current data from Firestore
      DocumentSnapshot snapshot = await documentRef.get();
      listData = snapshot.get('data') ?? [];

      // Check if the category already exists in the list
      categoryExists = listData.any((category) => category["Category"] == newCategory["Category"]);

      if (categoryExists) {
        showToast(msg: "The category has already been added to the list", textColor: Colors.orangeAccent);
        return;
      }

      // Add new category to Firestore if not already present
      await documentRef.set({
        "data": FieldValue.arrayUnion([newCategory]),
      }, SetOptions(merge: true));

      // Clear All Category fields Controller
      clearAllCategoryControllers();
      showToast(msg: "Category added successfully", textColor: Colors.green);
    } catch (e) {
      // Log the error and show user-friendly message
      print("Error adding new category: $e");
      showToast(msg: "Error adding new category: ${e.toString()}", textColor: Colors.redAccent);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> removeCategory({required String categoryName}) async {
    try {
      isLoading = true;
      notifyListeners();

      // Reference to the Firestore document
      final documentRef = FirebaseFirestore.instance.collection(collectionId).doc(documentId);

      // Fetch current data from Firestore
      DocumentSnapshot snapshot = await documentRef.get();
      listData = snapshot.get('data') ?? [];

      // Check if the category exists in the list
      final categoryIndex = listData.indexWhere((category) => category["Category"] == capitalizeEachWord(categoryName));

      if (categoryIndex == -1) {
        showToast(msg: "Category not found", textColor: Colors.orangeAccent);
        return;
      }

      // Remove the category from the list
      listData.removeAt(categoryIndex);

      // Update Firestore with the modified list
      await documentRef.update({
        "data": listData,
      });

      showToast(msg: "Category removed successfully", textColor: Colors.green);
    } catch (e) {
      // Log the error and show user-friendly message
      print("Error removing category: $e");
      showToast(msg: "Error removing category: ${e.toString()}", textColor: Colors.redAccent);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addNewProduct({required String productName, required String productType, required List<String> suitableFor}) async {
    final documentRef = FirebaseFirestore.instance.collection(collectionId).doc(documentId);

    if (productNameController.text.isEmpty) {
      showToast(msg: "Fill out the required fields", textColor: Colors.redAccent);
      return;
    }

    try {
      isLoading = true;
      notifyListeners();
      // Fetch the document snapshot
      DocumentSnapshot snapshot = await documentRef.get();

      listData = snapshot.get('data') ?? [];

      if (!snapshot.exists || snapshot.data() == null) {
        showToast(msg: "Category data not found", textColor: Colors.redAccent);
        return;
      }

      // Access the existing 'data' array
      List<dynamic> data = snapshot['data'];
      // Find the category you want to update (for example, we look for an empty category)
      var category = data.firstWhere((item) => item['Category'] == selectedCategory);

      if (category == null) {
        showToast(msg: "Selected category not found", textColor: Colors.orangeAccent);
        return;
      }

      // The new products to add (this would be the fetched data from Firebase)
      var newProducts = {};
      if (suitableFor.length == 1 && suitableFor.first == "") {
        newProducts = {
          "productName": capitalizeEachWord(productName),
          "productType": productType,
          "suitableFor": [],
        };
      } else {
        newProducts = {
          "productName": capitalizeEachWord(productName),
          "productType": productType,
          "suitableFor": capitalizeFirstLettersOfList(suitableFor),
        };
      }

      // Add new products to the existing products list
      category['products'].add(newProducts);

      // Update the Firestore document with the modified 'data' list
      await documentRef.update({
        'data': data,
      });

      clearAllProductControllers();
      showToast(msg: "Products successfully added to the $selectedCategory Category", textColor: Colors.green);
    } catch (e) {
      print("Error adding new category: $e");
      showToast(msg: "Error adding new category: ${e.toString()}", textColor: Colors.redAccent);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> removeProduct({
    required String productName,
    required String categoryName,
  }) async {
    final documentRef = FirebaseFirestore.instance.collection(collectionId).doc(documentId);

    try {
      isLoading = true;
      notifyListeners();

      // Fetch the document snapshot
      DocumentSnapshot snapshot = await documentRef.get();

      if (!snapshot.exists || snapshot.data() == null) {
        showToast(msg: "Category data not found", textColor: Colors.redAccent);
        return;
      }

      // Access the existing 'data' array
      List<dynamic> data = snapshot['data'];

      // Find the category where the product exists
      var category = data.firstWhere(
        (item) => item['Category'] == categoryName,
        orElse: () => null,
      );

      if (category == null) {
        showToast(msg: "Selected category not found", textColor: Colors.orangeAccent);
        return;
      }

      // Find the product within the category
      List<dynamic> products = category['products'] ?? [];
      var product = products.firstWhere(
        (item) => item['productName'] == productName,
        orElse: () => null,
      );

      if (product == null) {
        showToast(msg: "Product not found in the selected category", textColor: Colors.orangeAccent);
        return;
      }

      // Remove the product from the category
      products.remove(product);

      // Update the Firestore document with the modified 'data' list
      await documentRef.update({
        'data': data,
      });
      fetchFromServer();
      showToast(msg: "Product successfully removed from the $categoryName Category", textColor: Colors.green);
    } catch (e) {
      print("Error removing product: $e");
      showToast(msg: "Error removing product: ${e.toString()}", textColor: Colors.redAccent);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> addSuitableFor({
    required String categoryName,
    required String productName,
    required String newSuitableFor,
  }) async {
    if (newSuitableFor.isEmpty) {
      showToast(msg: "Fill out the required fields", textColor: Colors.redAccent);
      return;
    }
    final documentRef = FirebaseFirestore.instance.collection(collectionId).doc(documentId);
    newSuitableFor = capitalizeEachWord(newSuitableFor);
    try {
      isLoading = true;
      notifyListeners();

      // Fetch the document snapshot
      DocumentSnapshot snapshot = await documentRef.get();

      // Check if the document exists and has data
      if (!snapshot.exists || snapshot.data() == null) {
        showToast(msg: "Category data not found", textColor: Colors.redAccent);
        return;
      }

      // Access the existing 'data' array
      List<dynamic> data = snapshot['data'];

      // Find the category by name
      var category = data.firstWhere((item) => item['Category'] == categoryName, orElse: () => null);

      if (category == null) {
        showToast(msg: "Category not found", textColor: Colors.orangeAccent);
        return;
      }

      // Find the product by name within the category
      var product = category['products']?.firstWhere(
        (prod) => prod['productName'] == productName,
        orElse: () => null,
      );

      if (product == null) {
        showToast(msg: "Product not found", textColor: Colors.orangeAccent);
        return;
      }

      // Add the new string to the 'suitableFor' list if it doesn't already exist
      List<String> suitableForList = List<String>.from(product['suitableFor'] ?? []);
      if (!suitableForList.contains(newSuitableFor)) {
        suitableForList.add(newSuitableFor);
        product['suitableFor'] = suitableForList;

        // Update the Firestore document with the modified 'data' list
        await documentRef.update({
          'data': data,
        });

        showToast(msg: "$newSuitableFor successfully added to $productName", textColor: Colors.green);
      } else {
        showToast(msg: "$newSuitableFor is already in the list", textColor: Colors.orangeAccent);
      }
    } catch (e) {
      print("Error adding suitableFor: $e");
      showToast(msg: "Error adding suitableFor: ${e.toString()}", textColor: Colors.redAccent);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
