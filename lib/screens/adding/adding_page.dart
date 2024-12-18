import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_category.dart';
import 'package:zain_mobiles/screens/adding/product_adding_screen.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class AddingPage extends StatelessWidget {
  const AddingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);

    return Provider.of<DataBaseManagement>(context).isLoading
        ? LoadingScreen()
        : Column(
            children: [
              SizedBox(height: height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  children: List.generate(
                    2,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: [width * 0.025, 0.0][index]),
                        child: InkWell(
                          onTap: [
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCategory(),
                                ),
                              );
                            },
                            dataBase.listData.isNotEmpty
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductAddingScreen(
                                          category: dataBase.listData.map((item) => item['Category']).toList(),
                                          listData: dataBase.listData,
                                        ),
                                      ),
                                    );
                                  }
                                : null
                          ][index],
                          child: Container(
                            height: height * 0.12,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: [Colors.white, dataBase.listData.isNotEmpty ? Colors.white : Color.fromARGB(42, 154, 153, 153)][index],
                              border: Border.all(
                                color: [Color(0xFF5f3461), dataBase.listData.isNotEmpty ? Color(0xFF5f3461) : const Color.fromARGB(58, 128, 128, 128)][index],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                ["Create Category", "Add New Product"][index],
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: [Color(0xFF5f3461), dataBase.listData.isNotEmpty ? Color(0xFF5f3461) : Colors.white][index],
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
