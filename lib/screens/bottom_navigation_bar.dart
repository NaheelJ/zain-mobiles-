import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_page.dart';
import 'package:zain_mobiles/screens/home_page.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<AddProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: height * 0.08,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height * 0.045,
              width: width * 0.1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/minilogo.png"),
                ),
              ),
            ),
            Consumer<AddProductsProvider>(
              builder: (context, person, child) => Text(
                person.currentPage == 0 ? "Home" : "Add Products",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5f3461),
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(width: width * 0.1),
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: PageView(
        controller: provider.pageController,
        onPageChanged: (index) {
          provider.setSelectedPageIndex(index);
        },
        children: [
          HomePage(),
          AddingPage(),
        ],
      ),
      bottomNavigationBar: Consumer<AddProductsProvider>(
        builder: (context, person, child) => DotCurvedBottomNav(
          selectedIndex: person.currentPage,
          margin: EdgeInsets.all(0),
          scrollController: ScrollController(),
          hideOnScroll: true,
          indicatorColor: Color(0xFF5f3461),
          backgroundColor: Color(0xFF5f3461),
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeOut,
          indicatorSize: 5,
          borderRadius: 0,
          height: 70,
          onTap: (index) {
            person.setSelectedPageIndex(index);
            person.pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          items: [
            Icon(
              Icons.home,
              color: person.currentPage == 0 ? Color(0xffE2BBBF) : Color(0xffE9EAF8),
              size: 25,
            ),
            Icon(
              Icons.add_box_rounded,
              color: person.currentPage == 1 ? Color(0xffE2BBBF) : Color(0xffE9EAF8),
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
