import 'package:flutter/material.dart';

void main() {
  runApp(SenatorReservationApp());
}

class SenatorReservationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senator Reservaciones',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(),
    );
  }
}

// Pantalla principal del menú
class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Map<String, dynamic>> _reservaciones = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NuevaReservaScreen(
                      reservaciones: _reservaciones,
                    ),
                  ),
                );
              },
              child: const Text('Realizar una nueva reservación'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerReservacionesScreen(
                      reservaciones: _reservaciones,
                    ),
                  ),
                );
              },
              child: const Text('Ver Reservaciones'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImprimirReservacionesScreen(
                      reservaciones: _reservaciones,
                    ),
                  ),
                );
              },
              child: const Text('Imprimir reservaciones por restaurante'),
            ),
          ],
        ),
      ),
    );
  }
}

class NuevaReservaScreen extends StatefulWidget {
  final List<Map<String, dynamic>> reservaciones;

  const NuevaReservaScreen({required this.reservaciones});

  @override
  _NuevaReservaScreenState createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  String? _nombre;
  int? _cantidadPersonas;
  String? _restaurante;
  String? _hora;

  final Map<String, int> capacidadMaxima = {
    'Ember': 3,
    'Zao': 4,
    'Grappa': 2,
    'Larimar': 3
  };

  final List<String> restaurantes = ['Ember', 'Zao', 'Grappa', 'Larimar'];
  final List<String> horas = ['6-8 pm', '8-10 pm'];

  void _realizarReservacion() {
    if (_nombre != null && _cantidadPersonas != null && _restaurante != null && _hora != null) {
      int capacidadActual = 0;

      for (var reserva in widget.reservaciones) {
        if (reserva['restaurante'] == _restaurante && reserva['hora'] == _hora) {
          capacidadActual += (reserva['cantidadPersonas'] as int);
        }
      }

      if (capacidadActual + _cantidadPersonas! <= capacidadMaxima[_restaurante]!) {
        setState(() {
          widget.reservaciones.add({
            'nombre': _nombre,
            'cantidadPersonas': _cantidadPersonas,
            'restaurante': _restaurante,
            'hora': _hora,
          });
        });
        _mostrarDialogoConfirmacion();
      } else {
        _mostrarDialogoError();
      }
    }
  }

  void _mostrarDialogoConfirmacion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reservación exitosa"),
          content: Text("Reservación para $_nombre realizada exitosamente."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("No hay suficiente capacidad en el restaurante."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
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
        title: const Text('Nueva Reservación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nombre'),
              onChanged: (value) {
                setState(() {
                  _nombre = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Cantidad de Personas'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _cantidadPersonas = int.tryParse(value);
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Restaurante'),
              value: _restaurante,
              items: restaurantes.map((String restaurante) {
                return DropdownMenuItem<String>(
                  value: restaurante,
                  child: Text(restaurante),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _restaurante = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Hora'),
              value: _hora,
              items: horas.map((String hora) {
                return DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _hora = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _realizarReservacion,
              child: const Text('Realizar Reservación'),
            ),
          ],
        ),
      ),
    );
  }
}

class VerReservacionesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reservaciones;

  const VerReservacionesScreen({required this.reservaciones});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservaciones'),
      ),
      body: ListView.builder(
        itemCount: reservaciones.length,
        itemBuilder: (context, index) {
          final reserva = reservaciones[index];
          return ListTile(
            title: Text('${reserva['restaurante']} - ${reserva['hora']}'),
            subtitle: Text('Nombre: ${reserva['nombre']}, Personas: ${reserva['cantidadPersonas']}'),
          );
        },
      ),
    );
  }
}

class ImprimirReservacionesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> reservaciones;

  const ImprimirReservacionesScreen({required this.reservaciones});

  @override
  _ImprimirReservacionesScreenState createState() => _ImprimirReservacionesScreenState();
}

class _ImprimirReservacionesScreenState extends State<ImprimirReservacionesScreen> {
  String? _restauranteSeleccionado;
  String? _horaSeleccionada;

  final List<String> restaurantes = ['Ember', 'Zao', 'Grappa', 'Larimar'];
  final List<String> horas = ['6-8 pm', '8-10 pm'];

  List<Map<String, dynamic>> reservacionesFiltradas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imprimir Reservaciones por Restaurante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Seleccione Restaurante'),
              value: _restauranteSeleccionado,
              items: restaurantes.map((String restaurante) {
                return DropdownMenuItem<String>(
                  value: restaurante,
                  child: Text(restaurante),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _restauranteSeleccionado = value;
                  _filtrarReservaciones();
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Seleccione Hora'),
              value: _horaSeleccionada,
              items: horas.map((String hora) {
                return DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _horaSeleccionada = value;
                  _filtrarReservaciones();
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reservacionesFiltradas.length,
                itemBuilder: (context, index) {
                  final reserva = reservacionesFiltradas[index];
                  return ListTile(
                    title: Text('${reserva['restaurante']} - ${reserva['hora']}'),
                    subtitle: Text('Nombre: ${reserva['nombre']}, Personas: ${reserva['cantidadPersonas']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filtrarReservaciones() {
    setState(() {
      reservacionesFiltradas = widget.reservaciones.where((reserva) {
        return reserva['restaurante'] == _restauranteSeleccionado && reserva['hora'] == _horaSeleccionada;
      }).toList();
    });
  }
}
