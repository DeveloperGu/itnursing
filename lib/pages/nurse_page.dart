
import 'package:aula/global/ITColors.dart';
import 'package:aula/widgets/custom_field_widget.dart';
import 'package:aula/widgets/gradient_button_widget.dart';
import 'package:flutter/material.dart';



class EnfermeiroCadastroForm extends StatefulWidget {
  const EnfermeiroCadastroForm({super.key});
  @override
  State<EnfermeiroCadastroForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends State<EnfermeiroCadastroForm> {
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
        CustomField('Nome completo', _nomeCtrl, Icons.person_outline),
        CustomField('E-mail', _emailCtrl, Icons.email_outlined),
        CustomField('CPF', _cpfCtrl, Icons.badge_outlined),
        CustomField('Telefone (WhatsApp)', _telCtrl, Icons.phone_outlined),
        CustomField('Senha', _senhaCtrl, Icons.lock_outline, obscure: true),
        if (_role == 'enfermeiro') ...[
          const SizedBox(height: 4),
          CustomField('COREN', TextEditingController(), Icons.verified_outlined,
              hint: 'SP-123456'),
        ],
        const SizedBox(height: 20),
        GradientButton(label: 'Criar conta', onTap: () {
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

}