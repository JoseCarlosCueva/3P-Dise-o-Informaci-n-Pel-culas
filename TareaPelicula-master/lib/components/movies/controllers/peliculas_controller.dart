
import 'package:get/get.dart';
import 'package:peliculas_/components/movies/models/peliculas_model.dart';
import 'package:peliculas_/components/shared/request_handler.dart';
import 'package:peliculas_/components/shared/request_model.dart';
import 'package:peliculas_/components/utils/constantes.dart';

class PeliculasController extends GetxController{

  final _cargando = false.obs; //obs = valor de la variable puede cambiar 
  
  // Rx variable reactiva, valor puede cambiar
  final RxList<PeliculasModel> _listaPeliculas = <PeliculasModel>[].obs;

  //instancia de clase RequestHandler
  final _request = RequestHandler();

  late RequestModel response; //valor sera evaluado despues

  // reescribiendo el metodo onInit. Cuando se lance el controlador se ejecuta el metodo 
  // de getPeliculas
  @override
  void onInit() async{
    super.onInit();
    response = await getPeliculas();
  }

  //Metodo para obtener las peliculas
  Future<RequestModel> getPeliculas() async {
    cargando = true;

    final data = await _request.requestGet(host: host, endpoint: endpoint);

    if(data.results.isNotEmpty){
      //asignando datos
      //map itera los valores y los asignamos a la listaPeliculas
      listaPeliculas = data.results.map((param) => PeliculasModel.fromJson(param)).toList();
    }

    cargando = false;

    return data;

  }

  //Getters y Setters
  bool get cargando => _cargando.value;
  set cargando(bool value) => _cargando.value = value;

  List<PeliculasModel> get listaPeliculas => _listaPeliculas;
  set listaPeliculas(List<PeliculasModel> lista) => _listaPeliculas.assignAll(lista);

}

