import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/more_controller.dart';

class MorePage extends GetView<MoreController> {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.options.length,
          itemBuilder: (context, index) {
            final item = controller.options[index];
            return ListTile(
              leading:
                  Text(item['icon']!, style: const TextStyle(fontSize: 20)),
              title: Text(item['title']!),
            );
          },
        );
      }),
    );
  }
}
