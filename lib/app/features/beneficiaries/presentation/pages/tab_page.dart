import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/history_page.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/recharge_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  TabPageState createState() => TabPageState();
}

class TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mobile Recharge',
                  style: TextStyle(
                    fontFamily: GoogleFonts.kanit().fontFamily,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff425a91),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xffdae4e6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )),
                        color: Colors.white,
                      ),
                      controller: _tabController,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff425a91),
                      ),
                      tabs: const [
                        Tab(text: 'Recharge'),
                        Tab(text: 'History'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 24,
        ),
        child: TabBarView(
          controller: _tabController,
          children: const [
            RechargePage(),
            HistoryPage(),
          ],
        ),
      ),
    );
  }
}
