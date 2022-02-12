import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messageme_app/cubit/states.dart';
import 'package:messageme_app/network/cache_helper.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(InitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  bool showingSpinner = false;

  void showingSpinnerMethod(){
    showingSpinner = true;
    emit(ShowingSpinner());
  }
  void nonshowingSpinnerMethod(){
    showingSpinner = false;
    emit(NonShowingSpinner());
  }

  String invalid = '';

  void showingInvalid(String value){
    invalid = value;
    emit(ShowingInvalid());
  }
  bool? isDark=CacheHelper.getBool(key: 'isDark');
  void light(){
    isDark = !isDark!;
    CacheHelper.setBool(key: 'isDark', value: isDark!);
    emit(Brightness());
  }

}