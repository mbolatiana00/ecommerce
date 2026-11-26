import 'package:ecommerce/core/route/route_name.dart';
import 'package:ecommerce/core/theme/ecommerce_theme.dart';
import 'package:ecommerce/features/auth/presentation/widgets/password_stengh_bar.dart';
import 'package:ecommerce/features/auth/presentation/widgets/validators.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecommerce/features/auth/presentation/widgets/auth_button.dart';
import 'package:ecommerce/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:ecommerce/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:ecommerce/features/auth/presentation/widgets/social_buttons.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _acceptTerms = false;
  bool _termsError = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authProvider.notifier).reset());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final formOk = _formKey.currentState!.validate();
    setState(() => _termsError = !_acceptTerms);
    if (!formOk || !_acceptTerms) return;

    await ref.read(authProvider.notifier).register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Une erreur est survenue'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (next.status == AuthStatus.success) {
        // TODO : Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte créé avec succès'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final isLoading = ref.watch(authProvider.select((s) => s.isLoading));

    return AuthScaffold(
      title: 'Créer un compte ✨',
      subtitle: 'Rejoins-nous et découvre toutes nos offres',
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                controller: _nameCtrl,
                label: 'Nom complet',
                hint: 'Ex : Mbola Rakoto',
                icon: Icons.person_outline_rounded,
                validator: Validators.name,
                autofillHints: const [AutofillHints.name],
              ),
              const SizedBox(height: 18),
              AuthTextField(
                controller: _emailCtrl,
                label: 'Email',
                hint: 'exemple@email.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 18),
              AuthTextField(
                controller: _phoneCtrl,
                label: 'Téléphone',
                hint: '034 12 345 67',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phoneMg,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                autofillHints: const [AutofillHints.telephoneNumber],
              ),
              const SizedBox(height: 18),
              AuthTextField(
                controller: _passwordCtrl,
                label: 'Mot de passe',
                hint: 'Minimum 8 caractères',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                validator: Validators.password,
                autofillHints: const [AutofillHints.newPassword],
              ),
              PasswordStrengthBar(controller: _passwordCtrl),
              const SizedBox(height: 18),
              AuthTextField(
                controller: _confirmCtrl,
                label: 'Confirmer le mot de passe',
                hint: 'Répète ton mot de passe',
                icon: Icons.lock_reset_rounded,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    Validators.confirmPassword(v, _passwordCtrl.text),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _acceptTerms,
                      activeColor: AppTheme.primary,
                      isError: _termsError,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (v) => setState(() {
                        _acceptTerms = v ?? false;
                        _termsError = false;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: _termsError
                              ? Colors.redAccent
                              : Colors.grey.shade700,
                        ),
                        children: const [
                          TextSpan(text: "J'accepte les "),
                          TextSpan(
                            text: "conditions d'utilisation",
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: ' et la '),
                          TextSpan(
                            text: 'politique de confidentialité',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AuthButton(
                label: 'Créer mon compte',
                isLoading: isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 28),
              const SocialButtons(),
              const SizedBox(height: 28),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Déjà un compte ? ',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () =>
                          context.go(LoginRoute),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
