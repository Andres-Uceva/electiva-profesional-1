import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:taller1/modelos/universidad_fb.dart';
import 'package:taller1/servicios/universidad_service.dart';
import '../../widgets/custom_drawer.dart';

class UniversidadFbListView extends StatelessWidget {
  const UniversidadFbListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades Firebase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gestiona tus universidades en tiempo real'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: StreamBuilder<List<UniversidadFb>>(
        stream: UniversidadService.watchUniversidades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar universidades',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final universidades = snapshot.data ?? [];

          if (universidades.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 80,
                    color: colorScheme.primary.withAlpha(77),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay universidades',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para crear una',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withAlpha(179),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final bool useGrid = screenWidth > 600;
                final int crossAxisCount = screenWidth > 1200
                    ? 3
                    : screenWidth > 800
                        ? 2
                        : 1;
                final double padding = screenWidth > 600 ? 24 : 16;
                final double spacing = screenWidth > 600 ? 16 : 12;
                final double maxWidth = screenWidth > 1400 ? 1400 : double.infinity;

                Widget listContent;

                if (useGrid && crossAxisCount > 1) {
                  listContent = GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(padding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: screenWidth > 1200 ? 2.5 : 2.2,
                    ),
                    itemCount: universidades.length,
                    itemBuilder: (context, index) {
                      final uni = universidades[index];
                      return _UniversidadCard(
                        universidad: uni,
                        index: index,
                        isGridView: true,
                      );
                    },
                  );
                } else {
                  listContent = ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(padding),
                    itemCount: universidades.length,
                    itemBuilder: (context, index) {
                      final uni = universidades[index];
                      return _UniversidadCard(
                        universidad: uni,
                        index: index,
                        isGridView: false,
                      );
                    },
                  );
                }

                if (maxWidth < double.infinity) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: listContent,
                    ),
                  );
                }

                return listContent;
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/universidadesfb/create'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }
}

class _UniversidadCard extends StatelessWidget {
  final UniversidadFb universidad;
  final int index;
  final bool isGridView;

  const _UniversidadCard({
    required this.universidad,
    required this.index,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: isGridView ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha(77),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/universidadesfb/edit/${universidad.nit}'),
        child: Padding(
          padding: EdgeInsets.all(isGridView ? 12 : 16),
          child: isGridView
              ? _buildGridContent(context, colorScheme)
              : _buildListContent(context, colorScheme),
        ),
      ),
    );
  }

  Widget _buildListContent(BuildContext context, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                universidad.nombre,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text('NIT: ${universidad.nit}',
                style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                universidad.direccion.isEmpty ? 'Sin dirección' : universidad.direccion,
                style: TextStyle(
                  fontSize: 13,
                  color: universidad.direccion.isEmpty
                      ? colorScheme.onSurfaceVariant.withAlpha(128)
                      : colorScheme.onSurfaceVariant,
                  fontStyle: universidad.direccion.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                universidad.telefono.isEmpty ? 'Sin teléfono' : 'Tel: ${universidad.telefono}',
                style: TextStyle(
                  fontSize: 13,
                  color: universidad.telefono.isEmpty
                      ? colorScheme.onSurfaceVariant.withAlpha(128)
                      : colorScheme.onSurfaceVariant,
                  fontStyle: universidad.telefono.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                universidad.paginaweb.isEmpty ? 'Sin página web' : universidad.paginaweb,
                style: TextStyle(
                  fontSize: 13,
                  color: universidad.paginaweb.isEmpty
                      ? colorScheme.onSurfaceVariant.withAlpha(128)
                      : colorScheme.primary,
                  fontStyle: universidad.paginaweb.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                  decoration: universidad.paginaweb.isEmpty ? null : TextDecoration.underline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: colorScheme.error.withAlpha(204),
            size: 20,
          ),
          tooltip: 'Eliminar',
          visualDensity: VisualDensity.compact,
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  Widget _buildGridContent(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                universidad.nombre,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error.withAlpha(204),
                size: 18,
              ),
              tooltip: 'Eliminar',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('NIT: ${universidad.nit}',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          universidad.direccion.isEmpty ? 'Sin dirección' : universidad.direccion,
          style: TextStyle(
            fontSize: 12,
            color: universidad.direccion.isEmpty
                ? colorScheme.onSurfaceVariant.withAlpha(128)
                : colorScheme.onSurfaceVariant,
            fontStyle: universidad.direccion.isEmpty
                ? FontStyle.italic
                : FontStyle.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          universidad.telefono.isEmpty ? 'Sin teléfono' : 'Tel: ${universidad.telefono}',
          style: TextStyle(
            fontSize: 12,
            color: universidad.telefono.isEmpty
                ? colorScheme.onSurfaceVariant.withAlpha(128)
                : colorScheme.onSurfaceVariant,
            fontStyle: universidad.telefono.isEmpty
                ? FontStyle.italic
                : FontStyle.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          universidad.paginaweb.isEmpty ? 'Sin página web' : universidad.paginaweb,
          style: TextStyle(
            fontSize: 12,
            color: universidad.paginaweb.isEmpty
                ? colorScheme.onSurfaceVariant.withAlpha(128)
                : colorScheme.primary,
            fontStyle: universidad.paginaweb.isEmpty
                ? FontStyle.italic
                : FontStyle.normal,
            decoration: universidad.paginaweb.isEmpty ? null : TextDecoration.underline,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Estás seguro de eliminar esta universidad?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant.withAlpha(128),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    universidad.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('NIT: ${universidad.nit}', style: TextStyle(fontSize: 12)),
                  if (universidad.direccion.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Dirección: ${universidad.direccion}', style: TextStyle(fontSize: 12)),
                  ],
                  if (universidad.telefono.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Teléfono: ${universidad.telefono}', style: TextStyle(fontSize: 12)),
                  ],
                  if (universidad.paginaweb.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Web: ${universidad.paginaweb}', style: TextStyle(fontSize: 12, color: colorScheme.primary)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(fontSize: 12, color: colorScheme.error),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      try {
        await UniversidadService.deleteUniversidad(universidad.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Universidad "${universidad.nombre}" eliminada'),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
