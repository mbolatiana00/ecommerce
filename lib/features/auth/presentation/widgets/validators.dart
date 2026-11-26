class Validators {
  static String? required(String? value, [String field = 'Ce champ']) {
    if (value == null || value.trim().isEmpty) return '$field est obligatoire';
    return null;
  }

  static String? name(String? value) {
    final r = required(value, 'Le nom');
    if (r != null) return r;
    if (value!.trim().length < 3) return 'Au moins 3 caractères';
    return null;
  }

  static String? email(String? value) {
    final r = required(value, "L'email");
    if (r != null) return r;
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]{2,}$');
    if (!regex.hasMatch(value!.trim())) return 'Email invalide';
    return null;
  }

  /// Numéros malgaches : 032, 033, 034, 037, 038 (+ 261 accepté)
  static String? phoneMg(String? value) {
    final r = required(value, 'Le téléphone');
    if (r != null) return r;
    var digits = value!.replaceAll(RegExp(r'[\s.-]'), '');
    if (digits.startsWith('+261')) {
      digits = '0${digits.substring(4)}';
    } else if (digits.startsWith('261')) {
      digits = '0${digits.substring(3)}';
    }
    if (!RegExp(r'^03[23478]\d{7}$').hasMatch(digits)) {
      return 'Format attendu : 032, 033, 034, 037 ou 038 + 7 chiffres';
    }
    return null;
  }

  static String? password(String? value) {
    final r = required(value, 'Le mot de passe');
    if (r != null) return r;
    if (value!.length < 8) return 'Au moins 8 caractères';
    if (!RegExp(r'[A-Za-z]').hasMatch(value) ||
        !RegExp(r'\d').hasMatch(value)) {
      return 'Mélange lettres et chiffres';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final r = required(value, 'La confirmation');
    if (r != null) return r;
    if (value != original) return 'Les mots de passe ne correspondent pas';
    return null;
  }
}
