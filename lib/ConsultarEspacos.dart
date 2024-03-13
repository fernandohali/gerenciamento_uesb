// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_uesb/VisualizarEspaco.dart';


class Espaco {
  final String nome;
  final String local;
  final int capacidade;
  final String fotoUrl;

  Espaco({required this.nome, required this.local, required this.capacidade, required this.fotoUrl});
}

class ConsultarEspacos extends StatelessWidget {
  const ConsultarEspacos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Consultar Espaços'),
        ),
        body: MeuFormulario(),
      ),
    );
  }
}

class MeuFormulario extends StatefulWidget {
  @override
  _MeuFormularioState createState() => _MeuFormularioState();
}

class _MeuFormularioState extends State<MeuFormulario> {
  String dropdownValue = 'Jequié';
  Map<String, bool> values = {
    'Computadores': false,
    'Cadeiras': false,
    'Mesas': false,
    'Acessibilidade': false,
    'Ar condicionado': false,
    'Projetores': false,
    'Internet cabeada': false,
    'Internet wireless': false,
    'Quadro': false,
    'Bancada para notebook': false,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Form(
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nome do espaço',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Capacidade',
              ),
            ),
            DropdownButtonFormField<String>(
              value: dropdownValue,
              items: <String>['Jequié', 'Campus 2', 'Campus 3'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Campus',
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: values.keys.map((String key) {
                return Container(
                  width: 200.0,
                  child: CheckboxListTile(
                    title: Text(key, style: TextStyle(fontSize: 12.0)),
                    value: values[key],
                    onChanged: (bool? value) {
                      setState(() {
                        values[key] = value!;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaDeLocais()),
                );
              },
              child: Text('Consultar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ListaDeLocais extends StatelessWidget {
  final List<Espaco> espacos = [
    Espaco(nome: 'Sala 22', local: 'Joselia Navarro', capacidade: 40, fotoUrl: 'https://th.bing.com/th/id/R.14e648ee752a2393c1f73c7330560de6?rik=RPskrSLBMlQZ7Q&riu=http%3a%2f%2fwww2.uesb.br%2frevistaeletronica%2fwp-content%2fuploads%2f2017%2f08%2fDSC04076.jpg&ehk=oT5v4RjrBlzaYBkGo6BqK6XfEh7FnztgGI5R7ASZN8k%3d&risl=&pid=ImgRaw&r=0'),
    // Adicione mais espaços conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Text(
          'Espaços cadastrados',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView(
            children: espacos.map((Espaco espaco) {
              return Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Image.network(espaco.fotoUrl),
                      title: Text(espaco.nome),
                      subtitle: Text('Local: ${espaco.local}, Capacidade: ${espaco.capacidade}'),
                    ),
                    Center(
                      child: ElevatedButton(
                        child: Text('Visualizar'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisualizarEspaco(data: espaco),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class VisualizarEspaco extends StatefulWidget {
  final Espaco data;

  VisualizarEspaco({required this.data});

  @override
  _VisualizarEspacoState createState() => _VisualizarEspacoState();
}

class _VisualizarEspacoState extends State<VisualizarEspaco> {
  final _formKey = GlobalKey<FormState>();
  String problema = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.nome),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Local: ${widget.data.local}'),
            Text('Capacidade: ${widget.data.capacidade}'),
            Image.network(widget.data.fotoUrl),
            ElevatedButton(
              child: Text('Solicitar Manutenção'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Informe o problema'),
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              problema = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, informe o problema.';
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('Enviar'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Enviado para análise')),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}