import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Controladores para capturar texto
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Función para validar contraseñas
  void _savePassword() {
    String newPass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      _showMessage("Por favor llena ambos campos");
    } else if (newPass != confirmPass) {
      _showMessage("Las contraseñas no coinciden");
    } else {
      _showMessage("Contraseña actualizada exitosamente");
      Navigator.pop(context);
    }
  }

  // Función para mostrar SnackBar
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FF),
      appBar: AppBar(
        title: const Text("Cambiar Contraseña", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SizedBox(
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Campo 1: Nueva contraseña
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Nueva contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo 2: Confirmar contraseña
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirmar contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // Botón guardar con validación
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _savePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Guardar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}// TODO Implement this library.