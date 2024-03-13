// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:gerenciamento_uesb/ConsultarEspacos.dart';


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