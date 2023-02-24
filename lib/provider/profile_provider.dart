import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sixvalley_vendor_app/data/model/body/seller_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/seller_info.dart';
import 'package:sixvalley_vendor_app/data/repository/profile_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo profileRepo;

  ProfileProvider({@required this.profileRepo});

  SellerModel _userInfoModel;
  SellerModel get userInfoModel => _userInfoModel;
  int _userId;
  int get userId =>_userId;
  String _profileImage;
  String get profileImage =>_profileImage;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  bool _isLoading = false;
  bool get isLoading => _isLoading;



  Future<ResponseModel> getSellerInfo(BuildContext context) async {
    ResponseModel _responseModel;
    ApiResponse apiResponse = await profileRepo.getSellerInfo();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _userInfoModel = SellerModel.fromJson(apiResponse.response.data);
      _userId = _userInfoModel.id;
      _profileImage = _userInfoModel.image;
      print('amar id =====>$_userId');
      _responseModel = ResponseModel(true, 'successful');
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }





  Future<ResponseModel> updateUserInfo(SellerModel updateUserModel, SellerBody seller, File file, String token, String password) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileRepo.updateProfile(updateUserModel, seller, file, token, password);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = 'Success';
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, message);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return responseModel;
  }



  Future<ApiResponse> updateBalance(String balance, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo.updateBalance(balance);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      Navigator.pop(context);
      getSellerInfo(context);
      _isLoading = false;
     showCustomSnackBar(getTranslated('withdraw_request_sent_successfully', context), context, isToaster: true, isError: false);
    }
    else {
      _isLoading = false;
      Map _map = apiResponse.response.data;
      String message = _map['message'];
      showCustomSnackBar(message, context, isToaster: true);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponse> deleteCustomerAccount(BuildContext context) async {
    _isDeleting = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo.deleteUserAccount();
    if (apiResponse.response.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response.data;
      String message = map ['message'];
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      _isLoading = false;
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

}
