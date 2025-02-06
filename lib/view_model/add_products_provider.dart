import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProductsProvider extends ChangeNotifier {
// Sliding page Controller
  PageController pageController = PageController();
  int currentPage = 0;

  setSelectedPageIndex(index) {
    currentPage = index;
    notifyListeners();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////
//// Product Listing State management
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

  int selectedTypeIndex = 0;
  List<dynamic> selectedTypeList = [];
  List<bool> isDropDownOpen = [];
///////////////////////////////////////////////////////////////////////////////////////////////////////

  void assignSelectedTypeIndex(index) {
    selectedTypeIndex = index;
  }

  void setselectedTypeIndex(index) {
    selectedTypeIndex = index;
    notifyListeners();
  }

  void setDropDownsheet(index) {
    isDropDownOpen[index] = !isDropDownOpen[index];
    print(isDropDownOpen);
    notifyListeners();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////

  void assignSelectedTypeList({required List types, required List listData, required String categoryName}) {
    final List productList = listData.firstWhere((item) => item["Category"] == categoryName, orElse: () => null)["products"] ?? [];
    if (types.isNotEmpty) {
      List typeListdata = productList.where((item) => item["productType"] == types[selectedTypeIndex]).cast<Map<String, dynamic>>().toList();
      if (selectedTypeList.length != typeListdata.length) {
        selectedTypeList = typeListdata;
        assignProductFoundProductList(selectedTypeList);
      }
      return;
    }
    if (selectedTypeList.length != productList.length) {
      selectedTypeList = productList;
      assignProductFoundProductList(selectedTypeList);
    }
    return;
  }

  void setSelectedTypeList({required List types, required List listData, required String categoryName}) {
    final productList = listData.firstWhere((item) => item["Category"] == categoryName, orElse: () => null)["products"] ?? [];
    List typeListdata = [];
    typeListdata = productList.where((item) => item["productType"] == types[selectedTypeIndex]).cast<Map<String, dynamic>>().toList();
    selectedTypeList = typeListdata;
    notifyListeners();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////
//// Product Suitable Products Listing
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

  List suitableProducts = [];

  void assignSuitableProductsList({required List listData, required String categoryName, required String productName}) {
    var category = listData.firstWhere((item) => item['Category'] == categoryName, orElse: () => null);
    var product = category['products']?.firstWhere((prod) => prod['productName'] == productName, orElse: () => null);
    suitableProducts = product["suitableFor"] ?? [];
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///// Searching State management
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

  List<dynamic> categoryFoundproducts = [];
  List<dynamic> productFoundProducts = [];

///////////////////////////////////////////////////////////////////////////////////////////////////////
////// Product Searching Functions
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

  void assignCategoryFoundProductList({required List listData}) {
    categoryFoundproducts = listData;
  }

  void setCategoryFoundProductList({required List listData}) {
    categoryFoundproducts = listData;
    notifyListeners();
  }

  void runFilterCategory({required String enteringKey, required List listData}) {
    var result = [];

    // Check if the entered keyword is empty
    if (enteringKey.isEmpty) {
      // If the search field is empty or only contains white-space, display all products
      result = listData.toList();
    } else {
      // Filter products by the 'name' field (case-insensitive)
      result = listData.where((item) => item["Category"].toString().toLowerCase().contains(enteringKey.toLowerCase())).toList();
    }

    categoryFoundproducts = result;
    notifyListeners();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////
  /// Product Searching Functions
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

  void assignProductFoundProductList(currentproductList) {
    productFoundProducts = currentproductList;
    isDropDownOpen = List<bool>.generate(productFoundProducts.length, (index) => false);
  }

  void setProductFoundProductList(currentproductList) {
    productFoundProducts = currentproductList;
    isDropDownOpen = List<bool>.generate(productFoundProducts.length, (index) => false);
    notifyListeners();
  }

  void runFilterProduct({required String enteringKey, required String categoryName, required List listData}) {
    var result = [];

    // Check if the entered keyword is empty
    if (enteringKey.isEmpty) {
      // print(enteringKey);
      // If the search field is empty or only contains white-space, display all products
      result = selectedTypeList.toList();
      // print(result);
    } else {
      var category = listData.firstWhere((item) => item["Category"] == categoryName)["products"];
      // Filter products by the 'name' field (case-insensitive)
      result = category.where((item) => item.toString().toLowerCase().contains(enteringKey.toLowerCase())).toList();
    }

    productFoundProducts = result;
    isDropDownOpen = List<bool>.generate(productFoundProducts.length, (index) => false);
    notifyListeners();
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

void showToast({required String msg, required Color textColor}) {
  Fluttertoast.showToast(
    msg: msg, // The message to be shown
    toastLength: Toast.LENGTH_SHORT, // Duration of the toast
    gravity: ToastGravity.TOP, // Position of the toast
    backgroundColor: Colors.grey.shade300, // Background color
    textColor: textColor, // Text color
    fontSize: 14.0, // Font size
  );
}

String capitalizeEachWord(String input) {
  if (input.isEmpty) return input.trim(); // Handle empty strings
  return input
      .split(' ') // Split the input string into words
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()) // Capitalize each word
      .join(' '); // Join the words back together
}

List<String> capitalizeFirstLettersOfList(List<String> inputs) {
  return inputs.map((input) {
    if (input.trim().isEmpty) return input.trim(); // Handle empty strings
    return input.trim()[0].toUpperCase() + input.trim().substring(1).toLowerCase();
  }).toList();
}
