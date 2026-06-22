import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(_emailCtrl.text.trim(), _passwordCtrl.text);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('¡Registro exitoso! Inicia sesión'),
        backgroundColor: Color(0xFF2E7D32),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth.errorMessage ?? 'Error al registrar'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0A1A), Color(0xFF0F0F1A)],
              ),
            ),
          ),
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.secondary.withValues(alpha: 0.07),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [cs.primary, cs.secondary],
                      ).createShader(bounds),
                      child: Text(
                        'CREAR CUENTA',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Regístrate para guardar tu catálogo',
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: Colors.white38),
                    ),
                    const SizedBox(height: 40),
                    AuthTextField(
                      controller: _emailCtrl,
                      label: 'Correo electrónico',
                      hint: 'tu@correo.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Ingresa tu correo';
                        }
                        if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(v)) {
                          return 'Correo inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordCtrl,
                      label: 'Contraseña',
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white38,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                        if (v.length < 6) return 'Mínimo 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _confirmCtrl,
                      label: 'Confirmar contraseña',
                      hint: '••••••••',
                      icon: Icons.lock_person_outlined,
                      obscureText: _obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white38,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                        if (v != _passwordCtrl.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 36),
                    Consumer<AuthProvider>(
                      builder: (_, auth, _) => SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: auth.isLoading ? null : _onRegister,
                          child: auth.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text('CREAR CUENTA'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('¿Ya tienes cuenta? ',
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.white38)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Inicia sesión',
                            style: TextStyle(
                                color: cs.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
