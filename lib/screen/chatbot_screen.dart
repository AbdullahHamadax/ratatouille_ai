import 'package:flutter/material.dart';
import '../consts/app_color.dart';
import '../consts/typography.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                'assets/images/linguini.jpg',
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Linguini’s Chat Pot',
                  style:
                      TextStyle(color: AppColors.carlolinaBlue, fontSize: 25.0),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Always Cooking',
                      style:
                          TextStyle(color: AppColors.chracoal, fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.hunyadiYellow,
                  width: 2.0, // Border thickness
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.lapisLazuli,
              ),
            ),
          ),
        ),
      ),
      body: const Center(),
    );
  }
}
