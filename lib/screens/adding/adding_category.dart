import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/product_adding_screen.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  @override
  void initState() {
    super.initState();
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    dataBase.categoryNameController.clear();
    dataBase.categoryTypesController = [TextEditingController()];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    return Provider.of<DataBaseManagement>(context).isLoading
        ? LoadingScreen()
        : Consumer<AddProductsProvider>(
            builder: (context, person, child) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFF5f3461),
                  surfaceTintColor: Color(0xFF5f3461),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white)),
                  centerTitle: true,
                  title: Text(
                    "Create Category",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.03),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Category Name",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.005),
                        CustomTextField(controller: dataBase.categoryNameController),
                        SizedBox(height: height * 0.03),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Types",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.005),
                        Consumer<DataBaseManagement>(
                          builder: (context, person, child) => ListView.builder(
                            itemCount: dataBase.categoryTypesController.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: height * 0.01),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Consumer<AddProductsProvider>(
                                        builder: (context, person, child) => CustomTextField(controller: dataBase.categoryTypesController[index]),
                                      ),
                                    ),
                                    index != 0
                                        ? IconButton(
                                            onPressed: () {
                                              dataBase.removeTypeController(dataBase.categoryTypesController[index]);
                                            },
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              size: 40,
                                              color: const Color.fromARGB(255, 255, 176, 176),
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Consumer<AddProductsProvider>(
                            builder: (context, person, child) => InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                dataBase.addMoreTypes();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xffE2BBBF),
                                    size: 20,
                                  ),
                                  SizedBox(width: width * 0.01),
                                  Text(
                                    'Add More Type',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffE2BBBF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  color: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  height: height * 0.13,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: SizedBox(
                          height: 55,
                          child: Consumer<AddProductsProvider>(
                            builder: (context, person, child) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff5F3461),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                dataBase.addNewCategory(
                                  categoryName: dataBase.categoryNameController.text,
                                  type: dataBase.categoryTypesController.map((item) => item.text).toList(),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Create New Category',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.purpleAccent.shade100,
            ),
            SizedBox(height: 20),
            Text(
              "Loading...",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
