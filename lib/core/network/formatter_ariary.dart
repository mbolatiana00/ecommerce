/// Formate un montant en Ariary : 15000 -> "15 000 Ar"
String formatAr(num amount) {
  final value = amount.round();
  final digits = value.abs().toString();

  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }

  return '${value < 0 ? '-' : ''}$buffer Ar';
}