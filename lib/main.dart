import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MiExpoApp());

class MiExpoApp extends StatelessWidget {
  const MiExpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expo APIs',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  // -------------------------------------------------------------
  // FUNCIONALIDAD 1: DEEP LINKING CON WHATSAPP
  // -------------------------------------------------------------
  Future<void> _abrirWhatsApp(BuildContext context) async {
    // Reemplaza con un número real para la prueba
    final String numero = "573000000000"; 
    final String mensaje = "Hola, probando url_launcher desde Flutter.";
    final Uri url = Uri.parse("https://wa.me/$numero?text=${Uri.encodeComponent(mensaje)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
      );
    }
  }

  // -------------------------------------------------------------
  // FUNCIONALIDAD 2: PETICIÓN HTTP A TELEGRAM BOT API
  // -------------------------------------------------------------
  Future<void> _enviarMensajeTelegram(BuildContext context) async {
    // TODO: Recuerda ocultar el token antes de subir a GitHub
    final String botToken = "AQUI_TU_TOKEN"; 
    final String chatId = "AQUI_TU_CHAT_ID";
    final String mensaje = "¡Hola profe! Mensaje enviado desde la app del proyecto de Sistemas 🚀";

    final url = Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'chat_id': chatId, 'text': mensaje}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Mensaje enviado a Telegram con éxito!'), backgroundColor: Colors.green),
        );
      } else {
        throw Exception("Error de servidor");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el mensaje'), backgroundColor: Colors.red),
      );
    }
  }

  // -------------------------------------------------------------
  // INTERFAZ DE USUARIO (UI)
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expo APIs Udenar'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selecciona un método de comunicación:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Botón de WhatsApp
              ElevatedButton.icon(
                onPressed: () => _abrirWhatsApp(context),
                icon: const Icon(Icons.chat),
                label: const Text('Abrir WhatsApp (url_launcher)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Botón de Telegram
              ElevatedButton.icon(
                onPressed: () => _enviarMensajeTelegram(context),
                icon: const Icon(Icons.send),
                label: const Text('Enviar a Telegram Bot (http)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}