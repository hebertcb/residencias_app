import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/mispermisos_bloc.dart';
import 'package:residencias_app/models/permiso.dart';
import 'package:residencias_app/utils/date_utils.dart';
import 'package:residencias_app/widgets/loading_indicator.dart';

class MisPermisosView extends StatelessWidget {
  const MisPermisosView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MisPermisosBloc, PermisosState>(
      builder: (context, state) {
        if(state is PermisosLoading) {
          return LoadingIndicator();
        } else if(state is PermisosLoaded) {
          return _crearLista(state.permisos);
        } else {
          return Center(child: Text('(!) Ocurrió un error al cargar.'));
        }
      }
    );
  }

  Widget _crearLista(List<Permiso> lista) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final permiso = lista[index];
        if(permiso.isOK)
          return _crearPermisoItem( permiso, onTap: (){
            Navigator.pushNamed(context, 'detailPage', arguments: [permiso]);
          });
        else
          return _crearSolicitudItem( permiso, onTap: (){
            Navigator.pushNamed(context, 'detailPage', arguments: [permiso]);
          });
      }
    );
  }

  Widget _crearPermisoItem(Permiso permiso, { @required Function onTap }) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Column(       
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(DateUtils.formatDateTime(permiso.fsalida)),
            Text(DateUtils.formatDateTime(permiso.fentrada)),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:<Widget>[
            Text('${permiso.lugar}, ${permiso.motivo}'),
            Text(
              DateUtils.fechaCreado(permiso.createdAt),
              style: TextStyle(fontSize: 12.0)
            ),
          ]
        ),
        subtitle: Row(
          children: <Widget>[
            _crearEstado(permiso.operaciones),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _crearEstado(List<Operacion> operaciones) {
    String label = 'Culminado';
    Color color = Colors.grey;
    switch(operaciones.length) {
      case 1: label='Aprobado'; color=Colors.green; break;
      case 2: label='Salida'; color=Colors.blue; break;
      case 3: label='Entrada'; color=Colors.blue; break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: color,
      ),
      padding: EdgeInsets.all(1.0),
      child: Text(label, style: TextStyle(color: Colors.white),),
    );
  }

  Widget _crearSolicitudItem(Permiso permiso, { @required Function onTap }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side:BorderSide(color: Colors.grey,width: 2.0),
      ),
      elevation: 0.0,
      color: Colors.transparent,
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(DateUtils.formatDateTime(permiso.fsalida)),
            Text(DateUtils.formatDateTime(permiso.fentrada)),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:<Widget>[
            Text('${permiso.lugar}, ${permiso.motivo}'),
            Text(DateUtils.formatTime(permiso.createdAt),
            style: TextStyle(fontSize: 12.0),),
          ]
        ),
        subtitle: Text('Pendiente'),
        onTap: onTap,
      ),
    );
  }
}