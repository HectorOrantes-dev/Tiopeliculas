import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/pelicula_entity.dart';
import '../providers/peliculas_provider.dart';

class PeliculaFormScreen extends StatefulWidget {
  final PeliculaEntity? pelicula;

  const PeliculaFormScreen({super.key, this.pelicula});

  @override
  State<PeliculaFormScreen> createState() => _PeliculaFormScreenState();
}

class _PeliculaFormScreenState extends State<PeliculaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _generoCtrl;
  late final TextEditingController _anioCtrl;
  late final TextEditingController _descripcionCtrl;

  bool get _isEditing => widget.pelicula != null;

  static const _generos = [
    'Acción', 'Comedia', 'Drama', 'Terror', 'Romance',
    'Ciencia Ficción', 'Animación', 'Documental', 'Suspenso', 'Fantasía',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.pelicula;
    _tituloCtrl = TextEditingController(text: p?.titulo ?? '');
    _generoCtrl = TextEditingController(text: p?.genero ?? '');
    _anioCtrl = TextEditingController(
        text: p != null && p.anio > 0 ? p.anio.toString() : '');
    _descripcionCtrl = TextEditingController(text: p?.descripcion ?? '');
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _generoCtrl.dispose();
    _anioCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PeliculasProvider>();
    final pelicula = PeliculaEntity(
      id: widget.pelicula?.id ?? '',
      titulo: _tituloCtrl.text.trim(),
      genero: _generoCtrl.text.trim(),
      anio: int.tryParse(_anioCtrl.text) ?? 0,
      descripcion: _descripcionCtrl.text.trim(),
    );

    final bool ok;
    if (_isEditing) {
      ok = await provider.updatePelicula(widget.pelicula!.id, pelicula);
    } else {
      ok = await provider.createPelicula(pelicula);
    }

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isEditing
            ? 'Película actualizada correctamente'
            : 'Película agregada correctamente'),
        backgroundColor: const Color(0xFF2E7D32),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(provider.errorMessage ?? 'Error al guardar'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar película' : 'Nueva película'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.movie_rounded, color: cs.primary, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditing ? 'Editar película' : 'Nueva película',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isEditing
                                  ? 'Modifica los datos de la película'
                                  : 'Completa los datos para agregar',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SectionLabel(label: 'Información principal'),
              const SizedBox(height: 12),
              _FormField(
                controller: _tituloCtrl,
                label: 'Título',
                hint: 'Ej: El Señor de los Anillos',
                icon: Icons.title_rounded,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa el título';
                  if (v.trim().length < 2) return 'Mínimo 2 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Genre field with suggestions
              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) return _generos;
                  return _generos.where((g) => g
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (selection) {
                  _generoCtrl.text = selection;
                },
                fieldViewBuilder: (_, ctrl, focusNode, onSubmitted) {
                  _generoCtrl.addListener(() {
                    if (ctrl.text != _generoCtrl.text) {
                      ctrl.text = _generoCtrl.text;
                    }
                  });
                  return TextFormField(
                    controller: ctrl,
                    focusNode: focusNode,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (v) => _generoCtrl.text = v,
                    decoration: InputDecoration(
                      labelText: 'Género',
                      hintText: 'Ej: Acción, Drama...',
                      prefixIcon: const Icon(Icons.category_rounded),
                    ),
                    validator: (_) {
                      if (_generoCtrl.text.trim().isEmpty) {
                        return 'Ingresa el género';
                      }
                      return null;
                    },
                  );
                },
                optionsViewBuilder: (ctx, onSelected, options) => Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: const Color(0xFF252540),
                    borderRadius: BorderRadius.circular(12),
                    elevation: 8,
                    child: SizedBox(
                      width: MediaQuery.of(ctx).size.width - 40,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: options.length,
                        itemBuilder: (_, i) {
                          final opt = options.elementAt(i);
                          return ListTile(
                            dense: true,
                            leading: Icon(Icons.local_movies_rounded,
                                color: cs.primary, size: 18),
                            title: Text(opt,
                                style: const TextStyle(color: Colors.white70)),
                            onTap: () => onSelected(opt),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _FormField(
                controller: _anioCtrl,
                label: 'Año',
                hint: 'Ej: 2023',
                icon: Icons.calendar_month_rounded,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa el año';
                  final year = int.tryParse(v);
                  if (year == null || year < 1888 || year > 2100) {
                    return 'Año inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _SectionLabel(label: 'Descripción'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Escribe una breve sinopsis...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),
              Consumer<PeliculasProvider>(
                builder: (_, provider, _) => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading ? null : _onSave,
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Icon(_isEditing
                            ? Icons.save_rounded
                            : Icons.add_circle_rounded),
                    label: Text(_isEditing ? 'GUARDAR CAMBIOS' : 'AGREGAR PELÍCULA'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}
