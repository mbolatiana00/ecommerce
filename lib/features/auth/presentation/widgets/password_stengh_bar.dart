import 'package:material_ui/material_ui.dart';

class PasswordStrengthBar extends StatelessWidget {
  final TextEditingController controller;

  const PasswordStrengthBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final p = value.text;
        if (p.isEmpty) return const SizedBox.shrink();

        var score = 0;
        if (p.length >= 8) score++;
        if (RegExp(r'[A-Z]').hasMatch(p)) score++;
        if (RegExp(r'\d').hasMatch(p)) score++;
        if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score++;

        const labels = ['Très faible', 'Faible', 'Moyen', 'Bon', 'Excellent'];
        const colors = [
          Colors.redAccent,
          Colors.orange,
          Colors.amber,
          Color(0xFF66BB6A),
          Color(0xFF2E7D32),
        ];

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 5,
                      margin: EdgeInsets.only(right: i == 3 ? 0 : 6),
                      decoration: BoxDecoration(
                        color: i < score ? colors[score] : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                'Sécurité : ${labels[score]}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors[score],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
