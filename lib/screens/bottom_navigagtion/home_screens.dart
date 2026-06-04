import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/api/api_controller.dart';
import 'package:news_app/sort.dart';
import 'package:news_app/widgets/hovers/hover.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:news_app/widgets/newscards/news_card.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreens();
}

class _HomeScreens extends State<HomeScreens> {
  final ApiController data = Get.put(ApiController());
  final TextEditingController searching = TextEditingController();
  final SortController controller = Get.put(SortController());
  Timer? _searchdebouncer;
  void startsearch(String value) {
    if (_searchdebouncer?.isActive ?? false) {
      _searchdebouncer!.cancel();
    }
    _searchdebouncer = Timer(const Duration(milliseconds: 500), () {
      if (value.length > 3) {
        data.type.value = value;
        data.fetchnews();
      }
    });
  }

  @override
  void dispose() {
    _searchdebouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0.5,
        title: const Text(
          'Daily News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searching,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            startsearch(value);
                          }
                          else
                            {
                              data.type.value='india';
                              data.filter.value='everything';
                              data.queryfilter.value='';
                              data.fetchnews();
                            }

                        },
                        decoration: InputDecoration(
                          hintText: 'Search news...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: searching.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.grey),
                            onPressed: () {
                              searching.clear();
                              data.type.value = "india";
                              data.filter.value = "everything";
                              data.queryfilter.value = "";
                              data.fetchnews();
                            },
                          )
                              : const SizedBox.shrink(),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      CustomFilterChip(
                        label: 'Everything',
                        onTap: () {
                          data.filter.value = 'everything';
                          data.fetchnews();
                        },
                      ),
                      CustomFilterChip(
                        label: 'Popularity',
                        icon: Icons.trending_up,
                        onTap: () {
                          data.queryfilter.value = '&sortBy=popularity';
                          data.fetchnews();
                        },
                      ),
                      CustomFilterChip(
                        label: 'Business',
                        icon: Icons.business,
                        onTap: () {
                          data.queryfilter.value = '&category=business';
                          data.fetchnews();
                        },
                      ),
                      CustomFilterChip(
                        label: 'Top Headlines',
                        icon: Icons.star,
                        onTap: () {
                          data.filter.value = 'top-headlines';
                          data.fetchnews();
                        },
                      ),
                      CustomFilterChip(
                        label: 'Sort by Date',
                        icon: Icons.calendar_today,
                        isPrimary: true,
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text(
                                  'Select Date',
                                  style: TextStyle(fontWeight: FontWeight.bold)
                              ),
                              content: SizedBox(
                                width: 300,
                                height: 300,
                                child: Obx(() => DayPicker.single(
                                  selectedDate: controller.selecteddate.value,
                                  onChanged: (DateTime date) {
                                    controller.updatedate(date);
                                    String formatdate = DateFormat('yyyy-MM-dd').format(controller.selecteddate.value);
                                    data.queryfilter.value = '&from=$formatdate&sortBy=publishedAt';
                                    data.fetchnews();
                                    Get.back();
                                  },
                                  firstDate: DateTime.now().subtract(const Duration(days: 10)),
                                  lastDate: DateTime.now(),
                                )),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () async {
            data.fetchnews();
          },
          child: Column(
            children: [
              SizedBox(height: 200, child: Hover()),
              NewsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
class CustomFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const CustomFilterChip({
    Key? key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.yellow[700] : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPrimary ? Colors.transparent : Colors.grey[300]!,
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isPrimary ? Colors.black : Colors.black87,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.black : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
