import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Логотип
        SvgPicture.asset(
          'assets/logo.svg',
          height: 50,
          width: 50,
        ),
        // Кнопка "назад"
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15), // Скругленные углы
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back, // Стандартная иконка назад
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}