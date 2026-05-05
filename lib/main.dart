import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ITNursingApp());
}

// ─── Theme & Colors ───────────────────────────────────────────────────────────
class ITColors {
  static const blue900 = Color(0xFF05192F);
  static const blue800 = Color(0xFF0A2F4F);
  static const blue700 = Color(0xFF0F5C8D);
  static const blue500 = Color(0xFF1C7ED6);
  static const blue100 = Color(0xFFE8F2FB);
  static const gray900 = Color(0xFF0B2540);
  static const gray700 = Color(0xFF41536B);
  static const gray500 = Color(0xFF7C8BA1);
  static const gray200 = Color(0xFFD9E1EC);
  static const gray100 = Color(0xFFF5F7FB);
  static const success = Color(0xFF2F9E44);
  static const danger = Color(0xFFE03131);
  static const warning = Color(0xFFF08C00);
  static const surface = Colors.white;
  static const surfaceAlt = Color(0xFFF6F9FE);

  static const gradientPrimary = LinearGradient(
    colors: [blue900, blue700],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientAccent = LinearGradient(
    colors: [blue700, blue500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ─── App Root ─────────────────────────────────────────────────────────────────
class ITNursingApp extends StatelessWidget {
  const ITNursingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IT.Nursing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        colorScheme: ColorScheme.fromSeed(
          seedColor: ITColors.blue700,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F5FB),
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── Session State ────────────────────────────────────────────────────────────
class AppSession {
  static String? userRole; // 'enfermeiro', 'paciente', 'admin'
  static String? userName;
  static String? userEmail;
}

// ─── Splash Screen ────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, _slide(const LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: ITColors.gradientPrimary),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🏥',
                          style: TextStyle(fontSize: 56)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('IT.Nursing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      )),
                  const SizedBox(height: 8),
                  Text('Home Care conectado',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 15,
                        letterSpacing: 0.5,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Transitions ─────────────────────────────────────────────────────────────
PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 400),
    );

PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );

// ─── Login Page ───────────────────────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  bool _loading = false;
  bool _showPassword = false;
  bool _showCadastro = false;
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _tokenCtrl.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  void _doLogin() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    final email = _emailCtrl.text.trim();
    String? role;
    String? name;

    if (email == 'camila.enf@itnursing.com') {
      role = 'enfermeiro';
      name = 'Camila Ferreira';
    } else if (email == 'thiago.paciente@itnursing.com') {
      role = 'paciente';
      name = 'Thiago Santos';
    } else if (email == 'admin@itnursing.com') {
      role = 'admin';
      name = 'Administrador';
    } else if (email.isNotEmpty) {
      role = 'enfermeiro';
      name = email.split('@').first;
    }

    setState(() => _loading = false);

    if (role != null && mounted) {
      AppSession.userRole = role;
      AppSession.userName = name;
      AppSession.userEmail = email;
      _navigateByRole(role);
    } else {
      _showError('E-mail ou senha inválidos.');
    }
  }

  void _doAdminToken() async {
    if (_tokenCtrl.text.trim() == '0781') {
      AppSession.userRole = 'admin';
      AppSession.userName = 'Administrador';
      _navigateByRole('admin');
    } else {
      _showError('Token inválido.');
    }
  }

  void _navigateByRole(String role) {
    Widget page;
    switch (role) {
      case 'enfermeiro':
        page = const EnfermeiroDashboard();
        break;
      case 'paciente':
        page = const PacienteDashboard();
        break;
      case 'admin':
        page = const AdminMonitor();
        break;
      default:
        page = const EnfermeiroDashboard();
    }
    Navigator.pushReplacement(context, _fade(page));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ITColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ITColors.blue900, Color(0xFF0B355A), Color(0xFF0F5C8D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeTransition(
                  opacity: _headerFade,
                  child: _buildHero(),
                ),
                const SizedBox(height: 24),
                _buildAuthCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: const Center(child: Text('🏥', style: TextStyle(fontSize: 36))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HOME CARE INTELIGENTE',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                        letterSpacing: 2)),
                const SizedBox(height: 4),
                const Text('IT.Nursing',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Conectamos enfermeiros a pacientes\nHome Care com segurança.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 60,
              offset: const Offset(0, 24)),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle
          Row(
            children: [
              _tabBtn('Entrar', !_showCadastro, () => setState(() => _showCadastro = false)),
              const SizedBox(width: 8),
              _tabBtn('Criar conta', _showCadastro, () => setState(() => _showCadastro = true)),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showCadastro
                ? _CadastroForm(key: const ValueKey('cad'))
                : _buildLoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: active ? ITColors.gradientAccent : null,
            color: active ? null : ITColors.gray100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                  color: active ? Colors.white : ITColors.gray500,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel('E-mail'),
        _buildInput(_emailCtrl, 'camila.enf@itnursing.com',
            icon: Icons.email_outlined),
        const SizedBox(height: 14),
        _buildLabel('Senha'),
        _buildInput(_senhaCtrl, '••••••••',
            icon: Icons.lock_outline,
            obscure: !_showPassword,
            suffix: IconButton(
              icon: Icon(
                  _showPassword ? Icons.visibility_off : Icons.visibility,
                  color: ITColors.gray500),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            )),
        const SizedBox(height: 20),
        _GradientButton(
          label: 'Entrar',
          loading: _loading,
          onTap: _doLogin,
        ),
        const SizedBox(height: 24),
        Divider(color: ITColors.gray200, height: 1),
        const SizedBox(height: 20),
        Row(children: [
          const Icon(Icons.admin_panel_settings_outlined,
              size: 18, color: ITColors.gray500),
          const SizedBox(width: 8),
          Text('Acesso administrativo',
              style: TextStyle(
                  color: ITColors.gray700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ]),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildInput(_tokenCtrl, 'Token único (ex.: 0781)',
                  icon: Icons.vpn_key_outlined, obscure: true),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _doAdminToken,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: ITColors.gray100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ITColors.gray200),
                ),
                child: const Text('Liberar',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: ITColors.blue700,
                        fontSize: 13)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _QuickLoginHint(),
      ],
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: ITColors.gray700)),
      );

  Widget _buildInput(TextEditingController ctrl, String hint,
      {IconData? icon,
      bool obscure = false,
      Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(
        color: ITColors.gray100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ITColors.gray200),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        style: const TextStyle(color: ITColors.gray900, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: ITColors.gray500, fontSize: 14),
          prefixIcon: icon != null
              ? Icon(icon, color: ITColors.gray500, size: 20)
              : null,
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _QuickLoginHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hints = [
      ('Enfermeiro', 'camila.enf@itnursing.com', 'Enf12345'),
      ('Paciente', 'thiago.paciente@itnursing.com', 'Pac12345'),
      ('Admin', 'admin@itnursing.com', 'Admin123'),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ITColors.blue100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Usuários de teste',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: ITColors.blue700)),
          const SizedBox(height: 8),
          ...hints.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: ITColors.blue700,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(h.$1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Text(h.$2,
                        style: const TextStyle(
                            fontSize: 11, color: ITColors.gray700)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _CadastroForm extends StatefulWidget {
  const _CadastroForm({super.key});
  @override
  State<_CadastroForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends State<_CadastroForm> {
  String _role = 'paciente';
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Quero me cadastrar como',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: ITColors.gray700)),
        const SizedBox(height: 10),
        Row(
          children: ['paciente', 'enfermeiro'].map((r) {
            final sel = _role == r;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _role = r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? ITColors.blue100 : ITColors.gray100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: sel ? ITColors.blue500 : ITColors.gray200,
                        width: sel ? 2 : 1),
                  ),
                  child: Center(
                    child: Text(
                      r[0].toUpperCase() + r.substring(1),
                      style: TextStyle(
                          color: sel ? ITColors.blue700 : ITColors.gray500,
                          fontWeight: FontWeight.w700,
                          fontSize: 13),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _field('Nome completo', _nomeCtrl, Icons.person_outline),
        _field('E-mail', _emailCtrl, Icons.email_outlined),
        _field('CPF', _cpfCtrl, Icons.badge_outlined),
        _field('Telefone (WhatsApp)', _telCtrl, Icons.phone_outlined),
        _field('Senha', _senhaCtrl, Icons.lock_outline, obscure: true),
        if (_role == 'enfermeiro') ...[
          const SizedBox(height: 4),
          _field('COREN', TextEditingController(), Icons.verified_outlined,
              hint: 'SP-123456'),
        ],
        const SizedBox(height: 20),
        _GradientButton(label: 'Criar conta', onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Cadastro realizado! Faça login para continuar.'),
              backgroundColor: ITColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }),
      ],
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {bool obscure = false, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: ITColors.gray700)),
          ),
          Container(
            decoration: BoxDecoration(
              color: ITColors.gray100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ITColors.gray200),
            ),
            child: TextField(
              controller: ctrl,
              obscureText: obscure,
              style: const TextStyle(fontSize: 14, color: ITColors.gray900),
              decoration: InputDecoration(
                hintText: hint ?? label,
                hintStyle:
                    const TextStyle(color: ITColors.gray500, fontSize: 13),
                prefixIcon: Icon(icon, color: ITColors.gray500, size: 20),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gradient Button ──────────────────────────────────────────────────────────
class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _GradientButton(
      {required this.label, required this.onTap, this.loading = false});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: ITColors.gradientAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: ITColors.blue500.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : Text(widget.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.3)),
          ),
        ),
      ),
    );
  }
}

// ─── App Shell (with bottom nav) ──────────────────────────────────────────────
class AppShell extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> items;
  final String title;
  final String subtitle;

  const AppShell({
    super.key,
    required this.pages,
    required this.items,
    required this.title,
    required this.subtitle,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          decoration: const BoxDecoration(gradient: ITColors.gradientPrimary),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text('🏥', style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        Text(widget.subtitle,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                        context, _fade(const LoginPage())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Sair',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: widget.pages[_idx],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -4)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _idx,
          onTap: (i) => setState(() => _idx = i),
          selectedItemColor: ITColors.blue700,
          unselectedItemColor: ITColors.gray500,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 11),
          items: widget.items,
        ),
      ),
    );
  }
}

// ─── Enfermeiro Dashboard ─────────────────────────────────────────────────────
class EnfermeiroDashboard extends StatelessWidget {
  const EnfermeiroDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Painel do Enfermeiro',
      subtitle: 'Bem-vinda(o), ${AppSession.userName ?? "Enfermeiro"}!',
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Painel'),
        BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Vagas'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Assistente'),
      ],
      pages: [
        _EnfermeiroHome(),
        const VagasPage(),
        const PerfilPage(),
        const AssistentePage(),
      ],
    );
  }
}

class _EnfermeiroHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stats row
          Row(
            children: [
              _StatCard(value: '08', label: 'Candidaturas\nenviadas',
                  color: ITColors.blue700),
              const SizedBox(width: 12),
              _StatCard(value: '03', label: 'Em\nanálise',
                  color: ITColors.warning),
              const SizedBox(width: 12),
              _StatCard(value: '02', label: 'Entrevistas\nagendadas',
                  color: ITColors.success),
            ],
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Disponibilidade',
            child: Column(
              children: [
                _InfoRow(label: 'Próximo plantão', value: '12/12, 7h às 19h'),
                _InfoRow(label: 'Preferência', value: 'Noturno, escala 12x36'),
                _InfoRow(label: 'Habilidades',
                    value: 'Curativos complexos, ventilação mecânica'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Vagas recomendadas',
            child: Column(
              children: [
                _VagaCard(
                  title: 'Cuidados pós-cirúrgicos — Zona Sul',
                  desc: 'Paciente masculino, 72 anos. Plantão 12x36 — R\$ 4.200.',
                  badge: 'Nova',
                  badgeColor: ITColors.success,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _VagaCard(
                  title: 'Monitoramento noturno cardiológico',
                  desc: 'Paciente cardiópata, suporte medicamentoso. Plantão 22h–6h.',
                  badge: 'Prazo curto',
                  badgeColor: ITColors.warning,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Linha do tempo',
            child: Column(
              children: [
                _TimelineItem(
                    time: 'Hoje, 08h30',
                    text: 'Feedback recebido para candidatura "Cuidados paliativos".'),
                _TimelineItem(
                    time: 'Ontem, 17h10',
                    text: 'Entrevista confirmada com família Costa.'),
                _TimelineItem(
                    time: '12/12',
                    text: 'Disponibilidade atualizada para turnos noturnos.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Paciente Dashboard ───────────────────────────────────────────────────────
class PacienteDashboard extends StatelessWidget {
  const PacienteDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Área do Paciente',
      subtitle: 'Bem-vindo(a), ${AppSession.userName ?? "Paciente"}!',
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Nova vaga'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Minhas vagas'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Assistente'),
      ],
      pages: [
        _PacienteHome(),
        const RegistrarVagaPage(),
        const VagasPage(),
        const AssistentePage(),
      ],
    );
  }
}

class _PacienteHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: ITColors.gradientAccent,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color: ITColors.blue500.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Encontre o profissional ideal',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20)),
                const SizedBox(height: 8),
                Text('Cadastre sua necessidade e encontre enfermeiros qualificados.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85), fontSize: 13)),
                const SizedBox(height: 16),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text('Cadastrar vaga agora',
                        style: TextStyle(
                            color: ITColors.blue700,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatCard(value: '02', label: 'Vagas\nativas', color: ITColors.blue700),
              const SizedBox(width: 12),
              _StatCard(value: '05', label: 'Candidatos\nrecebidos', color: ITColors.success),
              const SizedBox(width: 12),
              _StatCard(value: '01', label: 'Contratado', color: ITColors.warning),
            ],
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Vagas publicadas',
            child: Column(
              children: [
                _VagaCard(
                  title: 'Cuidados pós-cirúrgicos — Zona Sul',
                  desc: 'Aberta • 3 candidatos interessados',
                  badge: 'Aberta',
                  badgeColor: ITColors.success,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Admin Monitor ────────────────────────────────────────────────────────────
class AdminMonitor extends StatelessWidget {
  const AdminMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Central de Monitoramento',
      subtitle: 'Visão estratégica',
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.monitor_heart_outlined), label: 'Monitor'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Métricas'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Conformidade'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Assistente'),
      ],
      pages: [
        _AdminHome(),
        _MetricasPage(),
        _ConformidadePage(),
        const AssistentePage(),
      ],
    );
  }
}

class _AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _StatCard(value: '42', label: 'Profissionais\nativos', color: ITColors.blue700),
              const SizedBox(width: 12),
              _StatCard(value: '18', label: 'Vagas\nabertas', color: ITColors.success),
              const SizedBox(width: 12),
              _StatCard(value: '07', label: 'Alertas\npendentes', color: ITColors.danger),
            ],
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Alertas recentes',
            child: Column(
              children: [
                _AlertItem(
                    icon: Icons.warning_amber_outlined,
                    color: ITColors.warning,
                    title: 'Documento vencido',
                    desc: 'Revisar COREN de Camila Ferreira.'),
                _AlertItem(
                    icon: Icons.message_outlined,
                    color: ITColors.blue500,
                    title: 'Fila de mensagens',
                    desc: '3 solicitações aguardando retorno.'),
                _AlertItem(
                    icon: Icons.security_outlined,
                    color: ITColors.danger,
                    title: 'Auditoria',
                    desc: 'Revisar logins suspeitos nas últimas 24h.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Mapa de operações',
            child: Column(
              children: [
                _OperacaoRow('São Paulo - SP', '08', '21', 'Normal', ITColors.success),
                _OperacaoRow('Guarulhos - SP', '05', '12', 'Monitorar', ITColors.warning),
                _OperacaoRow('Campinas - SP', '03', '07', 'Estável', ITColors.success),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _SectionCard(
            title: 'Status das vagas',
            child: Column(
              children: [
                _ProgressBar(label: 'Abertas', value: 0.45, color: ITColors.success),
                _ProgressBar(label: 'Em seleção', value: 0.3, color: ITColors.warning),
                _ProgressBar(label: 'Fechadas', value: 0.25, color: ITColors.danger),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Pipeline de profissionais',
            child: Column(
              children: [
                _InfoRow(label: 'Cadastros completos', value: '38'),
                _InfoRow(label: 'Documentos aprovados', value: '29'),
                _InfoRow(label: 'Ativos este mês', value: '42'),
                _InfoRow(label: 'Novos esta semana', value: '06'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Linha do tempo',
            child: Column(
              children: [
                _TimelineItem(time: 'Hoje, 09h', text: 'Nova candidatura recebida para vaga em Guarulhos.'),
                _TimelineItem(time: 'Ontem, 14h', text: 'Documento de Mariana Costa aprovado.'),
                _TimelineItem(time: '10/12', text: '3 novas vagas publicadas em São Paulo.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConformidadePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _SectionCard(
            title: 'Segurança',
            child: Column(
              children: [
                _CheckItem(label: 'Logs de acesso revisados semanalmente.', done: true),
                _CheckItem(label: 'Atualização de senhas administradores.', done: true),
                _CheckItem(label: 'Backups simulados no MVP.', done: false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Qualidade do atendimento',
            child: Column(
              children: [
                _CheckItem(label: 'Trilhas de feedback dos enfermeiros.', done: true),
                _CheckItem(label: 'Pesquisa de satisfação dos pacientes.', done: false),
                _CheckItem(label: 'Auditoria de documentos.', done: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vagas Page ───────────────────────────────────────────────────────────────
class VagasPage extends StatefulWidget {
  const VagasPage({super.key});
  @override
  State<VagasPage> createState() => _VagasPageState();
}

class _VagasPageState extends State<VagasPage> {
  String _filter = 'Todas';

  final _vagas = [
    {
      'title': 'Cuidados pós-cirúrgicos — Zona Sul',
      'desc': 'Paciente masculino, 72 anos. Plantão 12x36.',
      'status': 'Aberta',
      'city': 'São Paulo - SP',
      'pay': 'R\$ 4.200',
    },
    {
      'title': 'Monitoramento noturno cardiológico',
      'desc': 'Paciente cardiópata, suporte medicamentoso.',
      'status': 'Em seleção',
      'city': 'Guarulhos - SP',
      'pay': 'R\$ 3.800',
    },
    {
      'title': 'Cuidados paliativos domiciliares',
      'desc': 'Paciente oncológico, cuidados de conforto.',
      'status': 'Aberta',
      'city': 'Campinas - SP',
      'pay': 'R\$ 5.000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'Todas'
        ? _vagas
        : _vagas.where((v) => v['status'] == _filter).toList();

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: ['Todas', 'Aberta', 'Em seleção'].map((f) {
              final sel = _filter == f;
              return GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? ITColors.blue100 : ITColors.gray100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: sel ? ITColors.blue500 : Colors.transparent),
                  ),
                  child: Text(f,
                      style: TextStyle(
                          color: sel ? ITColors.blue700 : ITColors.gray500,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final v = filtered[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VagaDetailCard(vaga: v),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VagaDetailCard extends StatelessWidget {
  final Map<String, String> vaga;
  const _VagaDetailCard({required this.vaga});

  @override
  Widget build(BuildContext context) {
    final statusColor = vaga['status'] == 'Aberta'
        ? ITColors.success
        : vaga['status'] == 'Em seleção'
            ? ITColors.warning
            : ITColors.danger;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(vaga['title']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: ITColors.gray900)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(vaga['status']!,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(vaga['desc']!,
              style: const TextStyle(color: ITColors.gray500, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniTag(icon: Icons.location_on_outlined, text: vaga['city']!),
              const SizedBox(width: 8),
              _MiniTag(icon: Icons.attach_money, text: vaga['pay']!),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: ITColors.gradientAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Candidatar',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: ITColors.gray100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ITColors.gray200),
                ),
                child: const Text('Detalhes',
                    style: TextStyle(
                        color: ITColors.blue700, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Registrar Vaga ───────────────────────────────────────────────────────────
class RegistrarVagaPage extends StatelessWidget {
  const RegistrarVagaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ITColors.blue100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: ITColors.blue700, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Modo Demo — Preencha e simule o cadastro.',
                      style: TextStyle(
                          color: ITColors.blue700,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Dados da vaga',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FormField(label: 'Título da vaga',
                    hint: 'Ex.: Cuidador noturno para paciente cardíaco',
                    icon: Icons.work_outline),
                _FormField(label: 'Cidade / Bairro',
                    hint: 'Ex.: Guarulhos - SP',
                    icon: Icons.location_on_outlined),
                _FormField(label: 'Remuneração (R\$)',
                    hint: '5200,00',
                    icon: Icons.attach_money,
                    keyboard: TextInputType.number),
                _FormField(label: 'Horário / Escala',
                    hint: 'Plantão 12x36 — Noturno',
                    icon: Icons.schedule_outlined),
                _FormField(label: 'Contexto do paciente',
                    hint: 'Descreva o perfil, cuidados necessários e duração prevista.',
                    icon: Icons.description_outlined,
                    maxLines: 4),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _DropdownField(label: 'Status',
                        items: ['Aberta', 'Em seleção', 'Fechada'])),
                    const SizedBox(width: 12),
                    Expanded(child: _DropdownField(label: 'Prioridade',
                        items: ['Normal', 'Urgente', 'Programada'])),
                  ],
                ),
                const SizedBox(height: 20),
                _GradientButton(label: 'Simular cadastro', onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Vaga simulada com sucesso! ✅'),
                      backgroundColor: ITColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Perfil Page ──────────────────────────────────────────────────────────────
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isEnf = AppSession.userRole == 'enfermeiro';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Avatar card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: ITColors.gradientPrimary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    (AppSession.userName ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppSession.userName ?? 'Usuário',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isEnf ? 'Enfermeiro(a)' : 'Paciente',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Identificação',
            child: Column(
              children: [
                _InfoRow(label: 'Nome', value: AppSession.userName ?? '—'),
                _InfoRow(label: 'E-mail', value: AppSession.userEmail ?? '—'),
                _InfoRow(label: 'CPF', value: '•••.•••.•••-••'),
                if (isEnf) _InfoRow(label: 'COREN', value: 'SP-123456'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Status de verificação',
            child: Column(
              children: [
                _CheckItem(label: 'Selfie validada', done: true),
                _CheckItem(label: 'Documento validado', done: true),
                if (isEnf) _CheckItem(label: 'COREN ativo', done: false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (isEnf)
            _SectionCard(
              title: 'Perfil profissional',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FormField(label: 'Área de atuação',
                      hint: 'Ex.: UTI, cuidados paliativos',
                      icon: Icons.medical_services_outlined),
                  _FormField(label: 'Disponibilidade',
                      hint: 'Ex.: 12x36, noites, plantões',
                      icon: Icons.schedule_outlined),
                  _FormField(label: 'Especialidades',
                      hint: 'Curativos, Ventilação mecânica...',
                      icon: Icons.star_outline),
                  const SizedBox(height: 8),
                  _GradientButton(label: 'Salvar perfil', onTap: () {}),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Assistente (Chatbot) Page ────────────────────────────────────────────────
class AssistentePage extends StatefulWidget {
  const AssistentePage({super.key});
  @override
  State<AssistentePage> createState() => _AssitentePageState();
}

class _AssitentePageState extends State<AssistentePage> {
  final _msgs = <Map<String, String>>[
    {'role': 'bot', 'text': 'Olá! Sou o assistente do MVP IT.Nursing. Você é paciente, enfermeiro ou administrador?'},
  ];
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() => _msgs.add({'role': 'user', 'text': text}));
    _ctrl.clear();
    Future.delayed(const Duration(milliseconds: 600), () {
      String reply;
      final t = text.toLowerCase();
      if (t.contains('paciente')) {
        reply = 'Que bom ter você aqui! Para cadastrar vagas, vá até "Nova vaga" e preencha o formulário contando o contexto do paciente.';
      } else if (t.contains('enfermeiro')) {
        reply = 'Bem-vindo! Reforce que seu perfil está completo e visite o painel do enfermeiro para ver indicadores e vagas recomendadas.';
      } else if (t.contains('admin') || t.contains('0781')) {
        reply = 'Para acessar o painel administrativo, utilize o token único 0781 no login e será direcionado ao monitoramento.';
      } else if (t.contains('vaga')) {
        reply = 'Para cadastrar novas oportunidades, acesse a tela "Nova vaga". Lá você descreve o contexto do paciente.';
      } else {
        reply = 'Não entendi. Você é paciente, enfermeiro ou administrador? Posso te guiar com base nisso.';
      }
      if (mounted) {
        setState(() => _msgs.add({'role': 'bot', 'text': reply}));
        Future.delayed(const Duration(milliseconds: 100), () {
          _scroll.animateTo(_scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.all(20),
            itemCount: _msgs.length,
            itemBuilder: (_, i) {
              final m = _msgs[i];
              final isBot = m['role'] == 'bot';
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment:
                      isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isBot) ...[
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: ITColors.blue700,
                        child: const Text('🏥',
                            style: TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isBot ? Colors.white : ITColors.blue500,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isBot ? 4 : 18),
                            bottomRight: Radius.circular(isBot ? 18 : 4),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 8,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Text(m['text']!,
                            style: TextStyle(
                                color: isBot ? ITColors.gray900 : Colors.white,
                                fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Quick options
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Wrap(
            spacing: 8,
            children: ['Sou paciente', 'Sou enfermeiro', 'Sou administrador']
                .map((q) => GestureDetector(
                      onTap: () => _send(q),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: ITColors.blue100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ITColors.blue500),
                        ),
                        child: Text(q,
                            style: const TextStyle(
                                color: ITColors.blue700,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ),
                    ))
                .toList(),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: ITColors.gray100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: ITColors.gray200),
                  ),
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: _send,
                    decoration: const InputDecoration(
                      hintText: 'Digite sua pergunta...',
                      hintStyle: TextStyle(color: ITColors.gray500),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _send(_ctrl.text),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: ITColors.gradientAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatCard({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: ITColors.gray900)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text('$label:',
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ITColors.gray700,
                  fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: ITColors.gray500, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _VagaCard extends StatelessWidget {
  final String title;
  final String desc;
  final String badge;
  final Color badgeColor;
  final VoidCallback onTap;

  const _VagaCard({
    required this.title,
    required this.desc,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ITColors.gray100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ITColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: ITColors.gray900)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(badge,
                    style: TextStyle(
                        color: badgeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc,
              style: const TextStyle(color: ITColors.gray500, fontSize: 12)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: ITColors.gradientAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('Candidatar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String time;
  final String text;
  const _TimelineItem({required this.time, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 50,
            decoration: BoxDecoration(
              color: ITColors.blue500,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: ITColors.gray700)),
                const SizedBox(height: 3),
                Text(text,
                    style: const TextStyle(
                        color: ITColors.gray500, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  const _AlertItem(
      {required this.icon, required this.color, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: ITColors.gray900)),
                Text(desc,
                    style: const TextStyle(
                        color: ITColors.gray500, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperacaoRow extends StatelessWidget {
  final String cidade;
  final String vagas;
  final String profissionais;
  final String nivel;
  final Color nivelColor;
  const _OperacaoRow(this.cidade, this.vagas, this.profissionais, this.nivel, this.nivelColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(cidade,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: ITColors.gray900)),
          ),
          _badge('$vagas vagas', ITColors.blue700),
          const SizedBox(width: 6),
          _badge('$profissionais prof.', ITColors.gray500),
          const SizedBox(width: 6),
          _badge(nivel, nivelColor),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 11)),
      );
}

class _CheckItem extends StatefulWidget {
  final String label;
  final bool done;
  const _CheckItem({required this.label, required this.done});

  @override
  State<_CheckItem> createState() => _CheckItemState();
}

class _CheckItemState extends State<_CheckItem> {
  late bool _done;

  @override
  void initState() {
    super.initState();
    _done = widget.done;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _done = !_done),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _done ? ITColors.success : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: _done ? ITColors.success : ITColors.gray200,
                    width: 2),
              ),
              child: _done
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(widget.label,
                  style: TextStyle(
                      fontSize: 13,
                      color: _done ? ITColors.gray700 : ITColors.gray500,
                      decoration: _done ? TextDecoration.lineThrough : null)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _ProgressBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: ITColors.gray700)),
              Text('${(value * 100).toInt()}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: color, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MiniTag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ITColors.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: ITColors.gray500),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(fontSize: 12, color: ITColors.gray500)),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboard;
  const _FormField({
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: ITColors.gray700)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: ITColors.gray100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ITColors.gray200),
            ),
            child: TextField(
              maxLines: maxLines,
              keyboardType: keyboard,
              style: const TextStyle(fontSize: 14, color: ITColors.gray900),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: ITColors.gray500, fontSize: 13),
                prefixIcon: maxLines == 1
                    ? Icon(icon, color: ITColors.gray500, size: 20)
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatefulWidget {
  final String label;
  final List<String> items;
  const _DropdownField({required this.label, required this.items});

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: ITColors.gray700)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: ITColors.gray100,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: ITColors.gray200),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButton<String>(
            value: _selected,
            isExpanded: true,
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 14, color: ITColors.gray900),
            onChanged: (v) => setState(() => _selected = v!),
            items: widget.items
                .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
          ),
        ),
      ],
    );
  }
}