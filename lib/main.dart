import 'package:flutter/material.dart';

void main() {
  runApp(SenatorReservasApp());
}

class SenatorReservasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senator Reservas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal - Senator Reservas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NuevaReservaScreen()),
                );
              },
              child: Text('Realizar una Nueva Reservación'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerReservasScreen()),
                );
              },
              child: Text('Ver Reservaciones'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImprimirReservasScreen()),
                );
              },
              child: Text('Imprimir Reservas por Restaurante'),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla para nueva reserva
// Nueva reserva: Formulario
class NuevaReservaScreen extends StatefulWidget {
  @override
  _NuevaReservaScreenState createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _nombre;
  int? _cantidadPersonas;
  String? _restaurante;
  String? _hora;

  final List<String> restaurantes = ['Ember', 'Zao', 'Grappa', 'Larimar'];
  final List<String> horas = ['6-8 pm', '8-10 pm'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Reservación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de la Persona'),
                onSaved: (value) {
                  _nombre = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cantidad de Personas'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _cantidadPersonas = int.tryParse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad de personas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Seleccione Restaurante'),
                value: _restaurante,
                items: restaurantes.map((String restaurant) {
                  return DropdownMenuItem<String>(
                    value: restaurant,
                    child: Text(restaurant),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _restaurante = value;
                  });
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Seleccione Hora'),
                value: _hora,
                items: horas.map((String hour) {
                  return DropdownMenuItem<String>(
                    value: hour,
                    child: Text(hour),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _hora = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _realizarReservacion();
                  }
                },
                child: Text('Confirmar Reservación'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _realizarReservacion() {
    // Aquí agregaremos la lógica de reservación (verificar disponibilidad)
    if (_cantidadPersonas != null && _restaurante != null && _hora != null) {
      print('Reservación realizada para $_nombre en $_restaurante a las $_hora.');
      // Aquí puedes mostrar un diálogo de confirmación
    }
  }
}



// Pantalla para ver reservas
class VerReservasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Reservaciones'),
      ),
      body: Center(
        child: Text('Lista de Reservaciones'),
      ),
    );
  }
}

// Pantalla para imprimir reservas por restaurante
class ImprimirReservasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imprimir Reservas por Restaurante'),
      ),
      body: Center(
        child: Text('Listado de Reservaciones por Restaurante'),
      ),
    );
  }
}
