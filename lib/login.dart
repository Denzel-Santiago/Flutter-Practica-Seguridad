import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool bloqueado = false;

  @override
  void initState() {
    super.initState();
    iniciarSeguridad();
  }

  Future<void> iniciarSeguridad() async {
    await ScreenProtector.preventScreenshotOn();
    await verificarFakeGPS();
  }

  Future<void> verificarFakeGPS() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    if (position.isMocked) {
      setState(() {
        bloqueado = true;
      });
      mostrarAlerta();
    }
  }

  void mostrarAlerta() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fake GPS Detectado"),
          content: const Text(
            "La aplicación no puede ejecutarse porque se detectó una ubicación falsa.",
          ),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Seguro"),
      ),
      body: bloqueado
          ? const Center(
              child: Text(
                "Aplicación bloqueada",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Usuario",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Ingresar"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
